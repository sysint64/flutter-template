import 'dart:ui';

import 'package:localized_string/localized_string.dart';
import 'package:meta/meta.dart';
import 'package:forms/bloc.dart';

import 'data.dart';
import 'validators.dart';

@immutable
abstract class FormsEvent {}

class OnAddInput extends FormsEvent {
  final String fieldName;
  final FormValue value;
  final List<Validator> validators;
  final FormFieldPredicate enableRule;
  final FormFieldPredicate visibleRule;

  OnAddInput(
    this.fieldName,
    this.value,
    this.validators,
    this.enableRule,
    this.visibleRule,
  );
}

// NOTE(sysint64): We will sort widgets by vertical offset
//   to focus correct widget when validation error occur
class OnUpdateInputOffset extends FormsEvent {
  final String fieldName;
  final Offset offset;

  OnUpdateInputOffset(this.fieldName, this.offset);
}

class OnDisableInput extends FormsEvent {
  final String fieldName;

  OnDisableInput({this.fieldName});
}

class OnEnableInput extends FormsEvent {
  final String fieldName;

  OnEnableInput({this.fieldName});
}

class OnEnableInputWhere extends FormsEvent {
  final bool Function(String) where;

  OnEnableInputWhere(this.where);
}

class OnDisableInputWhere extends FormsEvent {
  final bool Function(String) where;

  OnDisableInputWhere(this.where);
}

class OnRemoveInput extends FormsEvent {
  final String fieldName;
  final bool saveState;

  OnRemoveInput({
    this.fieldName,
    this.saveState = true,
  });
}

class OnSubmit extends FormsEvent {
  final List<String> tags;
  final String actionName;

  OnSubmit({this.tags = const ['main'], this.actionName = 'submit'})
      : assert(tags != null),
        assert(actionName != null);
}

class OnUpdateValue<T> extends FormsEvent {
  final String fieldName;
  final FormValue<T> newValue;

  OnUpdateValue(this.fieldName, this.newValue);

  @override
  String toString() {
    return '$fieldName: $newValue';
  }
}

class OnRewriteValue<T> extends FormsEvent {
  final String fieldName;
  final FormValue<T> newValue;

  OnRewriteValue(this.fieldName, this.newValue);

  @override
  String toString() {
    return '$fieldName: $newValue';
  }
}

class OnFieldFocus extends FormsEvent {
  final String fieldName;

  OnFieldFocus(this.fieldName);
}

class OnRewriteValueFinished extends FormsEvent {
  final String fieldName;

  OnRewriteValueFinished(this.fieldName);
}

class OnRewriteFormValues extends FormsEvent {
  final Map<String, FormValue> newValues;

  OnRewriteFormValues(this.newValues);
}

// Rewrite fields value if it empty
class OnRewriteFormValuesFieldEmpty extends FormsEvent {
  final Map<String, FormValue> newValues;

  OnRewriteFormValuesFieldEmpty(this.newValues);
}

class OnFieldError extends FormsEvent {
  final String fieldName;
  final LocalizedString error;
  final bool requestFocus;

  OnFieldError(
    this.fieldName,
    this.error, {
    this.requestFocus = true,
  })  : assert(fieldName != null),
        assert(error != null),
        assert(requestFocus != null);
}

class OnFieldsError extends FormsEvent {
  final Map<String, LocalizedString> errors;
  final bool requestFocus;

  OnFieldsError({
    @required this.errors,
    this.requestFocus = true,
  })  : assert(errors != null),
        assert(requestFocus != null);
}

class OnFieldClearError extends FormsEvent {
  final String fieldName;

  OnFieldClearError(this.fieldName);
}

class OnClearAllErrors extends FormsEvent {}

class OnValidateForm extends FormsEvent {
  final List<String> tags;

  OnValidateForm({this.tags = const ['']}) : assert(tags != null);
}

class OnValidateField extends FormsEvent {
  final String fieldName;
  final List<String> tags;
  final bool requestFocusOnError;

  OnValidateField({
    @required this.fieldName,
    this.tags = const ['main'],
    this.requestFocusOnError = true,
  })  : assert(fieldName != null),
        assert(tags != null),
        assert(requestFocusOnError != null);
}
