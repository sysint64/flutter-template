import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:localized_string/localized_string.dart';
import 'package:optional/optional_internal.dart';

import 'bloc.dart';
import 'collections.dart';
import 'data.dart';

typedef OnFormSubmitCallback = Function(
  Map<String, FormValue> values,
  String actionName,
);

typedef FormFieldPredicate = bool Function(Map<String, FormValue> values);

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final bool initialIsValid;
  final bool validateOnUpdate;
  final bool validateOnFocusChange;
  final Duration onUpdateDebounceDuration;
  final OnFormSubmitCallback onSubmit;

  FormsBloc({
    this.initialIsValid = false,
    this.validateOnUpdate = true,
    this.validateOnFocusChange = true,
    this.onUpdateDebounceDuration = const Duration(milliseconds: 300),
    this.onSubmit,
  }) : super(FormsState(formIsValid: initialIsValid));

  AppFormFieldState _cloneFieldState<T>(
    String fieldName,
    FormsEvent event, {
    FormValue<T> value,
    FormValue<T> rewrittenValue,
    Optional<LocalizedString> errorMessage,
    bool isEnabled,
    Offset offset,
  }) {
    if (state.fieldStates.containsKey(fieldName)) {
      return state.fieldStates[fieldName].copyWith(
        event,
        value: value,
        rewrittenValue: rewrittenValue,
        errorMessage: errorMessage,
        isEnabled: isEnabled,
        offset: offset,
      );
    } else {
      return null;
    }
  }

  @override
  Stream<FormsState> mapEventToState(FormsEvent event) async* {
    if (event is OnAddInput) {
      yield* _mapOnAddInput(event);
    } else if (event is OnRemoveInput) {
      yield* _mapOnRemoveInput(event);
    } else if (event is OnSubmit) {
      yield* _mapOnSubmit(event);
    } else if (event is OnUpdateValue) {
      yield* _mapOnUpdateValue(event);
    } else if (event is OnRewriteValue) {
      yield* _mapOnRewriteValue(event);
    } else if (event is OnFieldError) {
      yield* _mapOnFieldError(event);
    } else if (event is OnFieldsError) {
      yield* _mapOnFieldsError(event);
    } else if (event is OnFieldClearError) {
      yield* _mapOnFieldClearError(event);
    } else if (event is OnClearAllErrors) {
      yield* _mapOnClearAllErrors(event);
    } else if (event is OnValidateForm) {
      yield* _mapOnValidateForm(event);
    } else if (event is OnValidateField) {
      yield* _mapOnValidateField(event);
    } else if (event is OnUpdateInputOffset) {
      yield* _mapOnUpdateInputOffset(event);
    } else if (event is OnRewriteFormValues) {
      yield* _mapOnUpdateFormValues(event);
    } else if (event is OnRewriteFormValuesFieldEmpty) {
      yield* _mapOnUpdateFormValuesFieldEmpty(event);
    } else if (event is OnRewriteValueFinished) {
      yield* _mapOnRewriteValueFinished(event);
    } else if (event is OnFieldFocus) {
      yield* _mapOnFieldFocus(event);
    } else {
      throw UnsupportedError('Unsupported event: $event');
    }
  }

  bool _isFormValid(Iterable<AppFormFieldState> fields) {
    for (final field in fields) {
      for (final validator in field.validators) {
        if (!validator.isValid(field.value)) {
          return false;
        }
      }
    }

    return true;
  }

  Stream<FormsState> _mapOnAddInput(OnAddInput event) async* {
    final focusNode = FocusNode();

    focusNode.addListener(() {
      if (validateOnFocusChange && !focusNode.hasFocus) {
        add(
          OnValidateField(
            fieldName: event.fieldName,
            requestFocusOnError: false,
          ),
        );
      }
    });

    yield state.copyWith(
      event,
      [event.fieldName],
      fieldStates: cloneMapAndAdd(
        state.fieldStates,
        event.fieldName,
        AppFormFieldState(
          value: _retrieveFieldValue(event.fieldName, event.value),
          validators: event.validators,
          focusNode: focusNode,
          visibleRule: event.visibleRule,
          enableRule: event.enableRule,
          event: event,
          key: GlobalKey(),
        ),
      ),
      removedFieldStates: cloneMapAndRemove(
        state.removedFieldStates,
        event.fieldName,
      ),
    );
  }

  FormValue _retrieveFieldValue(String fieldName, FormValue initialValue) {
    if (state.removedFieldStates.containsKey(fieldName)) {
      return state.removedFieldStates[fieldName].value;
    } else {
      return initialValue;
    }
  }

  Stream<FormsState> _mapOnRemoveInput(OnRemoveInput event) async* {
    if (event.saveState) {
      yield state.copyWith(
        event,
        [event.fieldName],
        fieldStates: cloneMapAndRemove(
          state.fieldStates,
          event.fieldName,
        ),
        removedFieldStates: cloneMapAndAdd(
          state.removedFieldStates,
          event.fieldName,
          state.fieldStates[event.fieldName],
        ),
      );
    } else {
      yield state.copyWith(
        event,
        [event.fieldName],
        fieldStates: cloneMapAndRemove(
          state.fieldStates,
          event.fieldName,
        ),
        removedFieldStates: cloneMapAndRemove(
          state.removedFieldStates,
          event.fieldName,
        ),
      );
    }
  }

  Stream<FormsState> _mapOnSubmit(OnSubmit event) async* {
    yield* _mapOnValidateForm(OnValidateForm(tags: event.tags));

    if (_isValid()) {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

      final states = state.fieldStates;
      final result = states.map((key, value) => MapEntry(key, value.value));

      if (onSubmit != null) {
        onSubmit(result, event.actionName);
      }
    }
  }

  bool _isValid() {
    final invalidFields = state.fieldStates.values.where((it) => it.errorMessage.isPresent);

    return invalidFields.isEmpty;
  }

  Stream<FormsState> _mapOnValidateForm(OnValidateForm event) async* {
    yield* _mapOnClearAllErrors(event);

    final sortedEntries = state.fieldStates.entries.toList();

    sortedEntries.sort(
      (a, b) => a.value.offset.dy.compareTo(b.value.offset.dy),
    );

    for (final entry in sortedEntries.reversed) {
      yield* _mapOnValidateField(
        OnValidateField(
          fieldName: entry.key,
          tags: event.tags,
        ),
      );
    }
  }

  Stream<FormsState> _mapOnValidateField(OnValidateField event) async* {
    final fieldState = state.fieldStates[event.fieldName];

    for (final validator in fieldState.validators) {
      if (fieldState.isEnabled &&
          !validator.isValid(fieldState.value) &&
          event.tags.contains(validator.tag)) {
        yield* _mapOnFieldError(
          OnFieldError(
            event.fieldName,
            validator.getValidationMessage(fieldState.value).value,
            requestFocus: event.requestFocusOnError,
          ),
        );
        break;
      } else {
        yield* _mapOnFieldClearError(OnFieldClearError(event.fieldName));
      }
    }
  }

  Stream<FormsState> _mapOnUpdateValue(OnUpdateValue event) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      event,
      value: event.newValue,
      rewrittenValue: null,
      errorMessage: const Optional.empty(),
    );

    if (fieldState == null) {
      return;
    }

    yield state.copyWith(
      event,
      [event.fieldName],
      fieldStates: cloneMapAndUpdate(
        state.fieldStates,
        event.fieldName,
        fieldState,
      ),
    );

    yield* _checkRules(event.fieldName, event);

    if (validateOnUpdate) {
      yield* _mapOnValidateField(
        OnValidateField(
          fieldName: event.fieldName,
          requestFocusOnError: false,
        ),
      );
    }
  }

  Stream<FormsState> _mapOnRewriteValueEmpyField(OnRewriteValue event) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      event,
      value: event.newValue,
      rewrittenValue: event.newValue,
      errorMessage: const Optional.empty(),
    );

    final states = state.fieldStates;
    final fieldValues = states.map((key, value) => MapEntry(key, value.value));
    final value = StringFormValue.getValue(fieldValues, event.fieldName);

    if (fieldState == null) {
      yield state.copyWith(
        event,
        [event.fieldName],
        fieldStates: cloneMapAndAdd(
          state.fieldStates,
          event.fieldName,
          AppFormFieldState(
            event: event,
            value: event.newValue,
            isEnabled: false,
            focusNode: FocusNode(),
            key: GlobalKey(),
          ),
        ),
      );
    } else if (value.isEmpty) {
      yield state.copyWith(
        event,
        [event.fieldName],
        fieldStates: cloneMapAndUpdate(
          state.fieldStates,
          event.fieldName,
          fieldState,
        ),
      );
    }
  }

  Stream<FormsState> _mapOnRewriteValue(OnRewriteValue event) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      event,
      value: event.newValue,
      rewrittenValue: event.newValue,
      errorMessage: const Optional.empty(),
    );

    if (fieldState == null) {
      yield state.copyWith(
        event,
        [event.fieldName],
        fieldStates: cloneMapAndAdd(
          state.fieldStates,
          event.fieldName,
          AppFormFieldState(
            event: event,
            value: event.newValue,
            isEnabled: false,
            focusNode: FocusNode(),
            key: GlobalKey(),
          ),
        ),
      );
    } else {
      yield state.copyWith(
        event,
        [event.fieldName],
        fieldStates: cloneMapAndUpdate(
          state.fieldStates,
          event.fieldName,
          fieldState,
        ),
      );
    }
  }

  Stream<FormsState> _mapOnRewriteValueFinished(
    OnRewriteValueFinished event,
  ) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      event,
      rewrittenValue: null,
    );

    if (fieldState != null) {
      yield state.copyWith(
        event,
        [event.fieldName],
        fieldStates: cloneMapAndUpdate(
          state.fieldStates,
          event.fieldName,
          fieldState,
        ),
      );

      yield* _checkRules(event.fieldName, event);
    }
  }

  Stream<FormsState> _mapOnFieldFocus(OnFieldFocus event) async* {
    state.fieldStates[event.fieldName].focusNode.requestFocus();
  }

  Stream<FormsState> _checkRules(String excludeFieldName, FormsEvent event) async* {
    final newState = <String, AppFormFieldState>{};
    final states = state.fieldStates;
    final fieldValues = states.map((key, value) => MapEntry(key, value.value));

    for (final fieldName in state.fieldStates.keys) {
      final fieldState = state.fieldStates[fieldName];
      newState[fieldName] = fieldState.copyWith(event);

      if (fieldName == excludeFieldName) {
        continue;
      }

      if (fieldState.visibleRule != null) {
        newState[fieldName] = newState[fieldName].copyWith(
          event,
          isVisible: fieldState.visibleRule(fieldValues),
        );
      }

      if (fieldState.enableRule != null) {
        newState[fieldName] = newState[fieldName].copyWith(
          event,
          isEnabled: fieldState.enableRule(fieldValues),
        );
      }
    }

    yield state.copyWith(event, [], fieldStates: newState);
  }

  Stream<FormsState> _mapOnFieldError(OnFieldError event) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      event,
      errorMessage: Optional.of(event.error),
    );

    if (fieldState == null) {
      return;
    }

    if (event.requestFocus) {
      fieldState.focusNode.requestFocus();
    }

    yield state.copyWith(
      event,
      [event.fieldName],
      formIsValid: false,
      fieldStates: cloneMapAndUpdate(
        state.fieldStates,
        event.fieldName,
        fieldState,
      ),
    );
  }

  Stream<FormsState> _mapOnFieldsError(OnFieldsError event) async* {
    final sortedEntries = state.fieldStates.entries.toList();

    sortedEntries.sort(
      (a, b) => a.value.offset.dy.compareTo(b.value.offset.dy),
    );

    for (final entry in sortedEntries) {
      final fieldName = entry.key;

      if (!event.errors.containsKey(fieldName)) {
        continue;
      }

      yield* _mapOnFieldError(
        OnFieldError(
          fieldName,
          event.errors[fieldName],
          requestFocus: fieldName == sortedEntries.first.key && event.requestFocus,
        ),
      );
    }
  }

  Stream<FormsState> _mapOnFieldClearError(OnFieldClearError event) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      event,
      errorMessage: const Optional.empty(),
    );

    if (fieldState == null) {
      return;
    }

    final fieldStates = cloneMapAndUpdate(
      state.fieldStates,
      event.fieldName,
      fieldState,
    );

    yield state.copyWith(
      event,
      [event.fieldName],
      formIsValid: _isFormValid(fieldStates.values),
      fieldStates: fieldStates,
    );
  }

  Stream<FormsState> _mapOnClearAllErrors(FormsEvent event) async* {
    yield state.copyWith(
      event,
      [],
      fieldStates: state.fieldStates.map(
        (key, value) => MapEntry(
          key,
          value.copyWith(
            event,
            errorMessage: const Optional.empty(),
          ),
        ),
      ),
    );
  }

  Stream<FormsState> _mapOnUpdateInputOffset(
    OnUpdateInputOffset event,
  ) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      event,
      offset: event.offset,
    );

    if (fieldState == null) {
      return;
    }

    yield state.copyWith(
      event,
      [event.fieldName],
      fieldStates: cloneMapAndUpdate(
        state.fieldStates,
        event.fieldName,
        fieldState,
      ),
    );
  }

  Stream<FormsState> _mapOnUpdateFormValuesFieldEmpty(OnRewriteFormValuesFieldEmpty event) async* {
    for (final fieldName in event.newValues.keys) {
      final updateEvent = OnRewriteValue(fieldName, event.newValues[fieldName]);
      yield* _mapOnRewriteValueEmpyField(updateEvent);
    }
  }

  Stream<FormsState> _mapOnUpdateFormValues(OnRewriteFormValues event) async* {
    for (final fieldName in event.newValues.keys) {
      final updateEvent = OnRewriteValue(fieldName, event.newValues[fieldName]);
      yield* _mapOnRewriteValue(updateEvent);
    }
  }
}
