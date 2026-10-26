import unittest

from verify_published_release import parse_apk_metadata


class PublicApkMetadataTest(unittest.TestCase):
    badging = ("package: name='org.spaceprotocol.space_client' versionCode='57' "
               "versionName='0.7.27' compileSdkVersion='36'\nsdkVersion:'24'\n")
    digest = 'a' * 64

    def test_current_android_tools_signer_output(self):
        result = parse_apk_metadata(self.badging, f'V2 Signer: certificate SHA-256 digest: {self.digest}\n')
        self.assertEqual(result, {'package': 'org.spaceprotocol.space_client',
                         'versionCode': 57, 'versionName': '0.7.27', 'minSdk': 24,
                         'certificates': [self.digest]})

    def test_multiple_signature_schemes_do_not_duplicate_certificate(self):
        signature = '\n'.join(f'V{version} Signer: certificate SHA-256 digest: {self.digest}'
                              for version in (2, 3))
        self.assertEqual(parse_apk_metadata(self.badging, signature)['certificates'], [self.digest])

    def test_public_key_digest_is_not_a_certificate(self):
        with self.assertRaises(ValueError):
            parse_apk_metadata(self.badging, f'V2 Signer: public key SHA-256 digest: {self.digest}\n')

    def test_missing_android_version_is_rejected(self):
        with self.assertRaises(ValueError):
            parse_apk_metadata(self.badging.replace("sdkVersion:'24'", ''),
                               f'V2 Signer: certificate SHA-256 digest: {self.digest}\n')


if __name__ == '__main__':
    unittest.main()
