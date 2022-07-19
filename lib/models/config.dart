import 'dart:io';

import 'package:conduit/conduit.dart';
class Config extends Configuration {
  Config(String fileName) : super.fromFile(File(fileName));
  String? gladiatorsurl;
  String? pythoncalc;
  String? frontend;
  String? publicKey;
  String? activategla;
  int? average;
  int? confirmations;
  DatabaseConfig? database;
  SmtpConfig? smtp;
}

class DatabaseConfig extends Configuration {
  String? username;
  String? password;
  String? host;
  int? port;
  String? dbName;
}
class SmtpConfig extends Configuration {
  String? username;
  String? password;
}
