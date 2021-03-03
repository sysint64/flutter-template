part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class OnError extends AppEvent {
  final Object exception;
  final StackTrace stackTrace;

  OnError(this.exception, this.stackTrace);
}

class OnSetEnabledDebugServices extends AppEvent {
  final bool isEnabled;

  OnSetEnabledDebugServices({this.isEnabled = false});
}
