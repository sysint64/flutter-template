import 'package:localized_string/localized_string.dart';
import 'package:drivers/exceptions/common.dart';
import 'package:drivers/strings.dart';

LocalizedString showExceptionMessage(Object exception) {
  if (exception is LocalizeMessageException) {
    if (exception.localizedMessage != null) {
      return exception.localizedMessage;
    } else {
      return DriversStrings.string((strings) => strings.unexpectedError);
    }
  } else {
    return DriversStrings.string((strings) => strings.unexpectedError);
  }
}
