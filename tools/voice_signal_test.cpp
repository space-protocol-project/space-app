#include "../client/vendor/flutter_webrtc/common/space_voice_signal.h"
#include <cassert>
#include <limits>
#include <thread>

int main() {
  SpaceVoiceSignal signal;
  float quiet[] = {1000, -1000};
  signal.SetGain(0.5f);
  signal.Process(quiet, 2);
  assert(quiet[0] == 500 && quiet[1] == -500);
  assert(std::abs(signal.level() - 500.0f / 32768) < 0.00001f);
  float loud[] = {30000, -30000, std::numeric_limits<float>::quiet_NaN()};
  signal.SetGain(2);
  signal.Process(loud, 3);
  assert(loud[0] == 32767 && loud[1] == -32768 && loud[2] == 0);
  assert(signal.level() > 0.8f && signal.level() <= 1);
  signal.SetGain(0);
  signal.Process(loud, 3);
  assert(loud[0] == 0 && loud[1] == 0 && signal.level() == 0);
  signal.Process(nullptr, 0);
  assert(signal.level() == 0);
  signal.SetGain(1);
  signal.SetTransmit(false);
  float speech[] = {1000, -1000};
  signal.Process(speech, 2);
  assert(speech[0] == 0 && speech[1] == 0);
  assert(signal.level() > 0);
  signal.SetTransmit(true);
  speech[0] = 1000;
  speech[1] = -1000;
  signal.Process(speech, 2);
  assert(speech[0] == 1000 && signal.level() > 0);
  std::thread writer([&signal] {
    for (int i = 0; i < 10000; ++i) signal.SetGain((i % 3) * 0.5f);
  });
  for (int i = 0; i < 10000; ++i) {
    float frame[] = {100, -100};
    signal.Process(frame, 2);
    assert(std::isfinite(signal.level()));
  }
  writer.join();
  signal.Reset();
  assert(signal.level() == 0);
}
