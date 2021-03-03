import 'package:localized_string/localized_string.dart';
import 'package:drivers/strings.dart';

import 'common.dart';

abstract class NetworkException implements LogicException {}

class ConnectionException implements NetworkException {
  @override
  LocalizedString get localizedMessage =>
      DriversStrings.string((s) => s.connectionError);
}

class NoInternetException implements NetworkException {
  @override
  LocalizedString get localizedMessage =>
      DriversStrings.string((s) => s.noInternetError);
}
