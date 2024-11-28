import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptionHelper {
  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
