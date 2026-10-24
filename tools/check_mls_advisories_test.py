import io
import json
import unittest
from unittest.mock import patch

import check_mls_advisories as checker


class AdvisoryChecks(unittest.TestCase):
    def run_response(self, response):
        with patch.object(checker, "dependencies", return_value=[("openmls", "0.9.0")]), \
             patch.object(checker.urllib.request, "urlopen", return_value=io.BytesIO(json.dumps(response).encode())), \
             patch("sys.stdout", new_callable=io.StringIO):
            checker.main()

    def test_vulnerability_fails_the_check(self):
        with self.assertRaises(SystemExit) as error:
            self.run_response({"results": [{"vulns": [{"id": "GHSA-test"}]}]})
        self.assertEqual(error.exception.code, 1)

    def test_empty_result_passes(self):
        self.run_response({"results": [{}]})

    def test_error_and_incomplete_results_fail(self):
        for response in ({"results": []}, {"results": [{"error": "unavailable"}]}):
            with self.assertRaises(RuntimeError):
                self.run_response(response)

    def test_macros_are_included(self):
        with patch.object(checker.subprocess, "check_output", return_value="serde_derive v1.0.229 (proc-macro)\n"):
            self.assertEqual(checker.dependencies(), [("serde_derive", "1.0.229")])

    def test_unknown_dependency_is_not_silently_ignored(self):
        with patch.object(checker.subprocess, "check_output", return_value="new-package v1.0.0 (git+https://example.invalid)\n"):
            with self.assertRaises(RuntimeError):
                checker.dependencies()

    def test_vendored_dependency_is_checked(self):
        for directory in (r"C:\work\native\vendor\provider", "/work/native/vendor/provider"):
            output = f"openmls_libcrux_crypto v0.4.0 ({directory})\n"
            with patch.object(checker.subprocess, "check_output", return_value=output):
                self.assertEqual(checker.dependencies(), [("openmls_libcrux_crypto", "0.4.0")])


if __name__ == "__main__":
    unittest.main()
