import 'package:localized_string/localized_string.dart';

import 'common.dart';

class FormErrorException implements LogicException {
  @override
  final LocalizedString localizedMessage;
  final Map<String, LocalizedString> errors;

  FormErrorException({this.errors, this.localizedMessage});
}
