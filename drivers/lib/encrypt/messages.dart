import 'dart:convert';

import 'package:drivers/exceptions/common.dart';
import 'package:drivers/json.dart';
import 'package:flutter/foundation.dart';
import 'package:serdes_json/annotations.dart';

part 'messages.g.dart';

@SerdesJson()
class HashVerifyMessageScheme {
  String hash;
  String value;
}

@SerdesJson()
class EncryptAES256Base64MessageScheme {
  String content;
  String keyBase64;
  String ivBase64;
}

@SerdesJson()
class DecryptAES256Base64MessageScheme {
  String contentBase64;
  String keyBase64;
  String ivBase64;
}
