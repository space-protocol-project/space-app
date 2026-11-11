import 'package:integration_test/integration_test.dart';

import '../test/extensions_p1_test.dart' as renderer;
import '../test/extensions_p1_form_test.dart' as forms;
import '../test/extensions_p1_ui_matrix_test.dart' as matrix;
import '../test/extensions_p1_contributions_test.dart' as contributions;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  renderer.main();
  forms.main();
  matrix.main();
  contributions.main();
}
