"""CI: два аварийных выключения QEMU и автоматическое восстановление при загрузке."""
import hashlib
import json
import os
from pathlib import Path
import socket
import subprocess
import tarfile
import tempfile
import time

IMAGE_ROOT = 'https://cloud-images.ubuntu.com/noble/current/'
IMAGE_NAME = 'noble-server-cloudimg-amd64.img'


def command(args, **kwargs):
    return subprocess.run(list(map(str, args)), check=True, timeout=240, **kwargs)


class Machine:
    def __init__(self, root, output):
        self.root, self.output, self.process = root, output, None
        with socket.socket() as listener:
            listener.bind(('127.0.0.1', 0))
            self.port = listener.getsockname()[1]
        self.accel = 'kvm' if os.access('/dev/kvm', os.R_OK | os.W_OK) else 'tcg'
        self.options = ['-i', str(root / 'key'), '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=3',
                        '-o', 'StrictHostKeyChecking=no', '-o', f'UserKnownHostsFile={root / "known_hosts"}']

    def ssh(self, script, check=True):
        result = subprocess.run(['ssh', *self.options, '-p', str(self.port), 'ci@127.0.0.1', script],
                                capture_output=True, text=True, timeout=60)
        if check and result.returncode:
            raise RuntimeError(f'{script}: {result.stderr} {result.stdout}')
        return result

    def copy(self, source, name):
        command(['scp', *self.options, '-P', self.port, source, f'ci@127.0.0.1:{name}'])

    def start(self, number):
        console = self.output / f'boot-{number}.log'
        self.process = subprocess.Popen([
            'qemu-system-x86_64', '-accel', self.accel, '-m', '2048', '-smp', '2',
            '-nographic', '-monitor', 'none', '-serial', f'file:{console}',
            '-drive', f'file={self.root / "disk.qcow2"},format=qcow2,if=virtio',
            '-drive', f'file={self.root / "seed.img"},format=raw,if=virtio',
            '-nic', f'user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:{self.port}-:22',
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        deadline = time.monotonic() + 240
        while self.ssh('test -f /home/ci/ready', check=False).returncode:
            assert self.process.poll() is None, console.read_text(errors='replace')[-4000:]
            assert time.monotonic() < deadline, 'VM boot timeout'
            time.sleep(1)
        return self.ssh('cat /proc/sys/kernel/random/boot_id').stdout.strip()

    def power_off(self):
        if self.process and self.process.poll() is None:
            self.process.kill()
            self.process.wait(timeout=10)


def prepare_image(root):
    command(['curl', '-fL', '--retry', '3', '--max-time', '180', IMAGE_ROOT + 'SHA256SUMS',
             '-o', root / 'SHA256SUMS'])
    command(['curl', '-fL', '--retry', '3', '--max-time', '180', IMAGE_ROOT + IMAGE_NAME,
             '-o', root / IMAGE_NAME])
    expected = next(line.split()[0] for line in (root / 'SHA256SUMS').read_text().splitlines()
                    if line.split()[-1].lstrip('*') == IMAGE_NAME)
    with (root / IMAGE_NAME).open('rb') as source:
        digest = hashlib.file_digest(source, 'sha256').hexdigest()
    assert digest == expected
    command(['qemu-img', 'create', '-f', 'qcow2', '-F', 'qcow2', '-b', root / IMAGE_NAME,
             root / 'disk.qcow2'])
    command(['ssh-keygen', '-q', '-t', 'ed25519', '-N', '', '-f', root / 'key'])
    key = (root / 'key.pub').read_text().strip()
    (root / 'user-data').write_text(
        '#cloud-config\nusers:\n  - name: ci\n    sudo: ALL=(ALL) NOPASSWD:ALL\n'
        '    lock_passwd: true\n    ssh_authorized_keys:\n      - ' + key + '\n'
        'ssh_pwauth: false\nruncmd:\n  - [touch, /home/ci/ready]\n')
    (root / 'meta-data').write_text('instance-id: space-wasm-boot-ci\nlocal-hostname: space-wasm-ci\n')
    command(['cloud-localds', root / 'seed.img', root / 'user-data', root / 'meta-data'])
    return digest


def package(root, binary):
    archive = root / 'package.tar'
    checksum = root / 'space-client-wasm.sha256'
    checksum.write_text(hashlib.sha256(binary.read_bytes()).hexdigest())
    with tarfile.open(archive, 'w') as output:
        output.add('packaging/linux-wasm', arcname='linux-wasm')
        output.add(binary, arcname='space-client-wasm')
        output.add(checksum, arcname='space-client-wasm.sha256')
    return archive


def leave_pending(vm):
    vm.ssh("cp -a space candidate; sed -i '/^\[Service\]/a ExecStartPre=/usr/bin/sleep 20' candidate/linux-wasm/space-client-wasm.service")
    vm.ssh("nohup sudo bash -c 'echo $$ > /run/space-ci-installer.pid; exec bash /home/ci/candidate/linux-wasm/install-system-service.sh /home/ci/candidate/space-client-wasm' > /home/ci/install.log 2>&1 < /dev/null &")
    deadline = time.monotonic() + 30
    while vm.ssh('sudo test -d /var/lib/space-client-wasm-updater/pending && test "$(systemctl show space-client-wasm.service -p ActiveState --value)" = activating', check=False).returncode:
        assert time.monotonic() < deadline, vm.ssh('cat install.log').stdout
        time.sleep(.2)
    vm.ssh('sudo kill -KILL "$(sudo cat /run/space-ci-installer.pid)"; sudo sync')
    vm.power_off()


def managed_hashes(vm):
    return vm.ssh('sha256sum /usr/libexec/space-client-wasm/space-client-wasm /etc/systemd/system/space-client-wasm.service /etc/systemd/system/space-client-wasm.socket').stdout


def verify_boot(vm, output, name, before, enabled):
    assert managed_hashes(vm) == before
    vm.ssh('sudo test ! -d /var/lib/space-client-wasm-updater/pending')
    vm.ssh('test "$(systemctl is-active space-client-wasm-recovery.service)" = active')
    health = vm.ssh('/usr/libexec/space-client-wasm/space-client-wasm --check-linux-broker', check=False)
    assert (health.returncode == 0) == enabled, health.stderr
    if enabled:
        stamps = vm.ssh('systemctl show space-client-wasm-recovery.service space-client-wasm.socket -p ActiveEnterTimestampMonotonic --value').stdout.split()
        assert len(stamps) == 2 and 0 < int(stamps[0]) <= int(stamps[1]), stamps
    else:
        vm.ssh('test "$(systemctl is-enabled space-client-wasm.socket)" = disabled && test ! -S /run/space-client-wasm/control.sock')
    journal = vm.ssh('sudo journalctl -b -u space-client-wasm-recovery.service --no-pager -o cat').stdout
    assert 'WASM boot recovery restored previous installation' in journal
    (output / f'{name}-recovery.log').write_text(journal)
    return {'case': name, 'files_restored': True, 'socket_enabled': enabled,
            'wasm_available': enabled, 'no_installer_after_boot': True}


def main():
    assert os.environ.get('GITHUB_ACTIONS') == 'true'
    output = Path('client-wasm-boot-vm')
    output.mkdir()
    with tempfile.TemporaryDirectory(dir=os.environ['RUNNER_TEMP']) as temporary:
        root = Path(temporary)
        digest = prepare_image(root)
        vm = Machine(root, output)
        try:
            boots = [vm.start(1)]
            vm.copy(package(root, Path(os.environ['SPACE_CLIENT_WASM_BINARY'])), 'package.tar')
            vm.ssh('mkdir space; tar -xf package.tar -C space; sudo bash space/linux-wasm/install-system-service.sh /home/ci/space/space-client-wasm')
            before = managed_hashes(vm)
            leave_pending(vm)
            boots.append(vm.start(2))
            cases = [verify_boot(vm, output, 'enabled', before, True)]
            vm.ssh('sudo systemctl disable --now space-client-wasm.socket; sudo systemctl stop space-client-wasm.service; rm -rf /home/ci/candidate')
            leave_pending(vm)
            boots.append(vm.start(3))
            cases.append(verify_boot(vm, output, 'disabled', before, False))
            assert len(set(boots)) == 3
            (output / 'result.json').write_text(json.dumps({
                'passed': True, 'cases': cases, 'boot_ids': boots, 'acceleration': vm.accel,
                'image_url': IMAGE_ROOT + IMAGE_NAME, 'image_sha256': digest,
                'shutdown': 'QEMU process SIGKILL after installer SIGKILL and guest sync',
            }, indent=2) + '\n')
        finally:
            vm.power_off()


if __name__ == '__main__':
    main()
