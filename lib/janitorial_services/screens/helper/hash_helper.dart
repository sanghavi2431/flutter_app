import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateHash(dynamic data) {
  final encoded = jsonEncode(data);
  return sha1.convert(utf8.encode(encoded)).toString();
}
