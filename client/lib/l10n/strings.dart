import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

extension SpaceStrings on BuildContext {
  AppLocalizations get strings =>
      AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('ru'));
}
