import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forms/l10n/messages_all.dart';
import 'package:intl/intl.dart';
import 'package:localized_string/localized_string.dart';

class FormStrings {
  static Future<FormStrings> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return FormStrings();
    });
  }

  static FormStrings of(BuildContext context) {
    return Localizations.of<FormStrings>(context, FormStrings);
  }

  static LocalizedString string(String Function(FormStrings strings) factory) =>
      LocalizedString.fromFactory(
          (context) => factory(FormStrings.of(context)));

  String get validationRequiredError => Intl.message(
        'This field is required',
        name: 'validationRequiredError',
      );

  String get validationOnlyDigitsError => Intl.message(
        'Only digits are accepted',
        name: 'validationRequiredError',
      );

  String get validationDecimalError => Intl.message(
        'Should be a valid number',
        name: 'validationRequiredError',
      );

  String get validationNonNegativeNumberError => Intl.message(
        'Only positive numbers are allowed',
        name: 'validationNonNegativeNumberError',
      );

  String get validationNonZeroNumberError => Intl.message(
        'Can\'t be zero',
        name: 'validationNonZeroNumberError',
      );

  String validationExactLengthError(int length) => Intl.message(
        'Length should be equals to $length',
        args: [length],
        name: 'validationExactLengthError',
      );

  String validationMinLengthError(int length) => Intl.message(
        'Field should have at least $length characters',
        args: [length],
        name: 'validationMinLengthError',
      );

  String validationWordCountError(int length) => Intl.message(
        'Field should have exactly $length words',
        args: [length],
        name: 'validationWordCountError',
      );

  String validationLatinLowerCaseError() => Intl.message(
        'Only latin lowercase are accepted',
        name: 'validationLatinLowerCaseError',
      );

  String validationPasswordError() => Intl.message(
        'Password must contain at least 6 characters, including: at least one uppercase and lowercase latin letter and number',
        name: 'validationPasswordError',
      );
}

class FormsStringsDelegate extends LocalizationsDelegate<FormStrings> {
  const FormsStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<FormStrings> load(Locale locale) {
    return FormStrings.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<FormStrings> old) {
    return false;
  }
}
