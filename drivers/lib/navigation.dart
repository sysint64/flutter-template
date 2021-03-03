import 'package:optional/optional.dart';

bool isNavigationSuccessResult<T>(T value) =>
    value != null && value is bool && value;

Optional<T> getNavigationResult<T, R>(R value) {
  if (value != null && value is T) {
    return Optional.of(value);
  } else {
    return const Optional.empty();
  }
}
