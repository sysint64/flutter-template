import 'package:forms/strings.dart';
import 'package:localized_string/localized_string.dart';
import 'package:optional/optional.dart';
import 'package:decimal/decimal.dart';

import 'data.dart';

abstract class Validator {
  String get tag;

  bool isValid<T>(FormValue<T> value);

  Optional<LocalizedString> getValidationMessage<T>(FormValue<T> value);
}

class RequiredValidator implements Validator {
  @override
  final String tag;

  RequiredValidator({this.tag = 'main'}) : assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (value.isEmpty()) {
      return Optional.of(
        FormStrings.string((strings) => strings.validationRequiredError),
      );
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    return !value.isEmpty();
  }
}

class OnlyDigitsValidator implements Validator {
  @override
  final String tag;

  OnlyDigitsValidator({this.tag = 'main'}) : assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      return Optional.of(
        FormStrings.string((strings) => strings.validationOnlyDigitsError),
      );
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    return value.isEmpty() ||
        value.data is! String ||
        RegExp(r'^[0-9]+$').hasMatch(value.data as String);
  }
}

class DecimalValidator implements Validator {
  @override
  final String tag;

  DecimalValidator({this.tag = 'main'}) : assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      return Optional.of(
        FormStrings.string((strings) => strings.validationDecimalError),
      );
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    return value.isEmpty() ||
        value.data is! String ||
        Decimal.tryParse(value.data as String) != null;
  }
}

class NonNegativeNumberValidator implements Validator {
  @override
  final String tag;

  NonNegativeNumberValidator({this.tag = 'main'}) : assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      return Optional.of(
        FormStrings.string(
          (strings) => strings.validationNonNegativeNumberError,
        ),
      );
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    return value.isEmpty() ||
        value.data is! String ||
        double.tryParse(value.data as String) == null ||
        double.parse(value.data as String) >= 0.0;
  }
}

class NonZeroNumberValidator implements Validator {
  @override
  final String tag;

  NonZeroNumberValidator({this.tag = 'main'}) : assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      return Optional.of(
        FormStrings.string(
          (strings) => strings.validationNonZeroNumberError,
        ),
      );
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    return value.isEmpty() ||
        value.data is! String ||
        double.tryParse(value.data as String) == null ||
        double.parse(value.data as String) > 0.0 ||
        double.parse(value.data as String) < 0.0;
  }
}

class ExactLengthValidator implements Validator {
  final int length;
  @override
  final String tag;

  ExactLengthValidator(this.length, {this.tag = 'main'})
      : assert(length != null),
        assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      return Optional.of(
        FormStrings.string(
          (strings) => strings.validationExactLengthError(length),
        ),
      );
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    return value.isEmpty() ||
        value.data is! String ||
        (value.data as String).length == length;
  }
}

class MinLengthValidator implements Validator {
  final int length;
  @override
  final String tag;

  MinLengthValidator(this.length, {this.tag = 'main'})
      : assert(length != null),
        assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      return Optional.of(
        FormStrings.string(
          (strings) => strings.validationExactLengthError(length),
        ),
      );
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    return value.isEmpty() ||
        value.data is! String ||
        (value.data as String).length >= length;
  }
}

class WordCountValidator implements Validator {
  final int length;
  @override
  final String tag;

  WordCountValidator(this.length, {this.tag = 'main'})
      : assert(length != null),
        assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      final _formStr = FormStrings.string(
          (strings) => strings.validationWordCountError(length));
      return Optional.of(_formStr);
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    final _len = (value.data as String).trim().split(' ').length == length;
    return value.isEmpty() || value.data is! String || _len;
  }
}

class OnlyLatinLowerCaseValidator implements Validator {
  @override
  final String tag;

  OnlyLatinLowerCaseValidator({this.tag = 'main'}) : assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      return Optional.of(FormStrings.string(
          (strings) => strings.validationLatinLowerCaseError()));
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    final _reg = RegExp(r'^[a-z\s]+$').hasMatch(value.data as String);
    return value.isEmpty() || value.data is! String || _reg;
  }
}

class PasswordValidator implements Validator {
  @override
  final String tag;

  PasswordValidator({this.tag = 'main'}) : assert(tag != null);

  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (!isValid(value)) {
      return Optional.of(
          FormStrings.string((strings) => strings.validationPasswordError()));
    } else {
      return const Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    final _reg = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$')
        .hasMatch(value.data as String);
    return value.isEmpty() || value.data is! String || _reg;
  }
}
