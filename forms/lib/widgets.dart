import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'data.dart';
import 'validators.dart';

class AppFormProvider extends StatelessWidget {
  final bool initialIsValid;
  final bool validateOnUpdate;
  final bool validateOnFocusChange;
  final Duration onUpdateDebounceDuration;
  final Widget child;
  final OnFormSubmitCallback onSubmit;
  final Key formKey;

  const AppFormProvider({
    Key key,
    this.formKey,
    this.child,
    this.initialIsValid = false,
    this.validateOnUpdate = true,
    this.validateOnFocusChange = true,
    this.onUpdateDebounceDuration = const Duration(microseconds: 300),
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormsBloc>(
      create: (context) => FormsBloc(
        initialIsValid: initialIsValid,
        validateOnUpdate: validateOnUpdate,
        validateOnFocusChange: validateOnFocusChange,
        onUpdateDebounceDuration: onUpdateDebounceDuration,
        onSubmit: onSubmit,
      ),
      child: SizedBox(key: formKey, child: child),
    );
  }
}

class AppForm extends StatelessWidget {
  final Widget Function(BuildContext, FormsState) builder;

  const AppForm({
    Key key,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(builder: builder);
  }
}

class AppFormField<T> extends StatefulWidget {
  final Widget Function(BuildContext, AppFormFieldState<T>) builder;
  final List<Validator> validators;
  final FormFieldPredicate enableRule;
  final FormFieldPredicate visibleRule;
  final FormValue<T> Function() initValue;
  final String fieldName;
  final BlocBuilderCondition<FormsState> buildWhen;

  const AppFormField({
    @required this.builder,
    @required this.initValue,
    @required this.fieldName,
    this.enableRule = null,
    this.visibleRule = null,
    this.buildWhen = null,
    this.validators = const [],
    Key key,
  })  : assert(builder != null),
        assert(validators != null),
        assert(initValue != null),
        assert(fieldName != null),
        super(key: key);

  @override
  _AppFormFieldState<T> createState() => _AppFormFieldState<T>();
}

class _AppFormFieldState<T> extends State<AppFormField<T>> {
  FormValue<T> _value;
  FormsBloc _bloc;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _value = widget.initValue();
    _bloc = BlocProvider.of<FormsBloc>(context);
    _bloc.add(
      OnAddInput(
        widget.fieldName,
        _value,
        widget.validators,
        widget.enableRule,
        widget.visibleRule,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateInputOffset());
  }

  _updateInputOffset() {
    final RenderBox renderBoxRed = _key.currentContext.findRenderObject();
    final position = renderBoxRed.localToGlobal(Offset.zero);

    _bloc.add(OnUpdateInputOffset(widget.fieldName, position));
  }

  @override
  void dispose() {
    if (_bloc != null) {
      // TODO(sysint64): maybe uncomment
//      _bloc.add(
//        OnRemoveInput(
//          fieldName: widget.fieldName,
//          saveState: true,
//        ),
//      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      key: _key,
      buildWhen: (previousState, state) {
        final contains = state.updateOnlyFields.contains(widget.fieldName);
        final isEmpty = state.updateOnlyFields.isEmpty;
        final customCond = widget.buildWhen?.call(previousState, state) ?? true;
        return (contains || isEmpty) && customCond;
      },
      builder: (context, state) {
        if (state.fieldStates.containsKey(widget.fieldName)) {
          final fieldState = state.fieldStates[widget.fieldName];
          return widget.builder(
            context,
            AppFormFieldState<T>(
              focusNode: fieldState.focusNode,
              errorMessage: fieldState.errorMessage,
              isEnabled: fieldState.isEnabled,
              value: fieldState.value,
              rewrittenValue: fieldState.rewrittenValue,
              validators: fieldState.validators,
              offset: fieldState.offset,
              visibleRule: fieldState.visibleRule,
              enableRule: fieldState.enableRule,
              key: fieldState.key,
              event: fieldState.event,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
