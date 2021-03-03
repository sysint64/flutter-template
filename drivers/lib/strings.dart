import 'dart:ui';

import 'package:drivers/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localized_string/localized_string.dart';

class DriversStrings {
  static Future<DriversStrings> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return DriversStrings();
    });
  }

  static DriversStrings of(BuildContext context) {
    return Localizations.of<DriversStrings>(context, DriversStrings);
  }

  static LocalizedString string(
          String Function(DriversStrings strings) factory) =>
      LocalizedString.fromFactory(
          (context) => factory(DriversStrings.of(context)));

  String get connectionError => Intl.message(
        'Ошибка подключения',
        name: 'connectionError',
      );

  String get noInternetError => Intl.message(
        'Интернет соединение отсутствует',
        name: 'noInternetError',
      );

  String get unexpectedError =>
      Intl.message('Unexpected error', name: 'unexpectedError');

  String get notAuthError => Intl.message(
        'Пользователь не авторизован',
        name: 'notAuthError',
      );
}

class DriversStringsDelegate extends LocalizationsDelegate<DriversStrings> {
  const DriversStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<DriversStrings> load(Locale locale) {
    return DriversStrings.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<DriversStrings> old) {
    return false;
  }
}
