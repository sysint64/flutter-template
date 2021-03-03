import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms/forms_bloc.dart';

export 'forms_bloc.dart';
export 'forms_event.dart';
export 'forms_state.dart';

FormsBloc form(BuildContext context) => BlocProvider.of<FormsBloc>(context);
