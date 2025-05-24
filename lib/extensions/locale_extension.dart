import 'package:flutter/material.dart';
import 'package:safmobile_portal/l10n/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
