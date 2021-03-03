part of 'app_bloc.dart';

@immutable
class AppState {
  final Optional<AppError> lastError;

  const AppState({
    this.lastError = const Optional.empty(),
  });

  AppState copyWith({
    Optional<AppError> lastError,
  }) {
    return AppState(
      lastError: lastError ?? this.lastError,
    );
  }
}
