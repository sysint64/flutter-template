import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:optional/optional.dart';
import 'package:serdes_json/annotations.dart';
import 'package:drivers/exceptions/common.dart';
import 'package:drivers/json.dart';

part 'schemes.g.dart';

@SerdesJson(convertToSnakeCase: true)
class ExampleResponseScheme {
  String test;
  Optional<String> optional;
}
