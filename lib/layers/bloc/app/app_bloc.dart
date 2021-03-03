import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_template/layers/models/domain/error.dart';
import 'package:flutter_template/layers/routers/router.dart';
import 'package:optional/optional.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppRouter _router;
  // final DeubgFloatPanelUIService _debugFloatButtonService;

  AppBloc(
    this._router,
    // this._debugFloatButtonService,
  ) : super(const AppState());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is OnError) {
      yield* _onError(event);
    } else if (event is OnSetEnabledDebugServices) {
      yield* _onSetEnabledDebugServices(event);
    } else {
      throw StateError('Unknown event: $event');
    }
  }

  Stream<AppState> _onError(OnError event) async* {
    final error = AppError(event.exception, event.stackTrace);
    yield state.copyWith(
      lastError: Optional.of(error),
    );
  }

  Future<void> _onDebugServicesClick() async {
    // await _debugFloatButtonService.hideDeubgPanel();
    // await _router.openDebugServices();
    // await _debugFloatButtonService.showDebugPanel(_onDebugServicesClick);
  }

  Stream<AppState> _onSetEnabledDebugServices(OnSetEnabledDebugServices event) async* {
    // if (event.isEnabled) {
    // await _debugFloatButtonService.showDebugPanel(_onDebugServicesClick);
    // } else {
    // await _debugFloatButtonService.hideDeubgPanel();
    // }
  }
}
