import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:password/password.dart';

import 'messages.dart';

abstract class Hasher {
  Future<String> hash(String value);

  Future<bool> verify(String value, String hash);
}

class HashMD5 implements Hasher {
  @override
  Future<String> hash(String value) {
    return compute(_hashMD5, value);
  }

  @override
  Future<bool> verify(String value, String hash) {
    final message = HashVerifyMessage(value: value, hash: hash);
    return compute(_hashVerifyTaskMD5, jsonEncode(message.toJson()));
  }
}

class HashSHA1 implements Hasher {
  @override
  Future<String> hash(String value) {
    return compute(_hashSHA1, value);
  }

  @override
  Future<bool> verify(String value, String hash) {
    final message = HashVerifyMessage(value: value, hash: hash);
    return compute(_hashVerifyTaskSHA1, jsonEncode(message.toJson()));
  }
}

class HashSHA256 implements Hasher {
  @override
  Future<String> hash(String value) {
    return compute(_hashSHA256, value);
  }

  @override
  Future<bool> verify(String value, String hash) {
    final message = HashVerifyMessage(value: value, hash: hash);
    return compute(_hashVerifyTaskSHA256, jsonEncode(message.toJson()));
  }
}

class HashPBKDF2 implements Hasher {
  @override
  Future<String> hash(String value) {
    return compute(_hashPBKDF2, value);
  }

  @override
  Future<bool> verify(String value, String hash) {
    final message = HashVerifyMessage(value: value, hash: hash);
    return compute(_hashVerifyTaskMD5, jsonEncode(message.toJson()));
  }
}

bool _hashVerifyTaskSHA256(String jsonMessage) {
  final jsonBody = jsonDecode(jsonMessage) as Map<String, dynamic>;
  final message = HashVerifyMessage.fromJson(jsonBody);

  return _hashSHA256(message.value) == message.hash;
}

String _hashSHA256(String value) {
  return utf8.decode(
    crypto.sha256.convert(utf8.encode(value)).bytes,
    allowMalformed: true,
  );
}

bool _hashVerifyTaskSHA1(String jsonMessage) {
  final jsonBody = jsonDecode(jsonMessage) as Map<String, dynamic>;
  final message = HashVerifyMessage.fromJson(jsonBody);

  return _hashSHA1(message.value) == message.hash;
}

String _hashSHA1(String value) {
  return utf8.decode(
    crypto.sha1.convert(utf8.encode(value)).bytes,
    allowMalformed: true,
  );
}

bool _hashVerifyTaskMD5(String jsonMessage) {
  final jsonBody = jsonDecode(jsonMessage) as Map<String, dynamic>;
  final message = HashVerifyMessage.fromJson(jsonBody);

  return _hashMD5(message.value) == message.hash;
}

String _hashMD5(String value) {
  return utf8.decode(
    crypto.md5.convert(utf8.encode(value)).bytes,
    allowMalformed: true,
  );
}

bool _passwordHashVerifyTaskPBKDF2(String jsonMessage) {
  final jsonBody = jsonDecode(jsonMessage) as Map<String, dynamic>;
  final message = HashVerifyMessage.fromJson(jsonBody);

  return _hashPBKDF2(message.value) == message.hash;
}

String _hashPBKDF2(String value) {
  return Password.hash(value, PBKDF2());
}

Future<String> encryptAES256Base64(
  encrypt.Key key,
  encrypt.IV iv,
  String content,
) async {
  final message = EncryptAES256Base64Message(
    content: content,
    keyBase64: key.base64,
    ivBase64: iv.base64,
  );
  return compute(_encryptAES256Base64Task, jsonEncode(message.toJson()));
}

Future<String> decryptAES256Base64(
  encrypt.Key key,
  encrypt.IV iv,
  String content,
) async {
  final message = DecryptAES256Base64Message(
    contentBase64: content,
    keyBase64: key.base64,
    ivBase64: iv.base64,
  );
  return compute(_decryptAES256Base64Task, jsonEncode(message.toJson()));
}

Future<String> _encryptAES256Base64Task(String jsonMessage) async {
  final jsonBody = jsonDecode(jsonMessage) as Map<String, dynamic>;
  final message = EncryptAES256Base64Message.fromJson(jsonBody);
  final key = encrypt.Key.fromBase64(message.keyBase64);
  final iv = encrypt.IV.fromBase64(message.ivBase64);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  return encrypter.encrypt(message.content, iv: iv).base64;
}

Future<String> _decryptAES256Base64Task(String jsonMessage) async {
  final jsonBody = jsonDecode(jsonMessage) as Map<String, dynamic>;
  final message = DecryptAES256Base64Message.fromJson(jsonBody);
  final key = encrypt.Key.fromBase64(message.keyBase64);
  final iv = encrypt.IV.fromBase64(message.ivBase64);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypt.Encrypted.fromBase64(message.contentBase64);
  return encrypter.decrypt(encrypted, iv: iv);
}
