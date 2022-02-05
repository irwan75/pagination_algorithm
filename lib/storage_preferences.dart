import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class SessionLogin {
  int tgl;
  int bln;
  int thn;
  SessionLogin({
    this.tgl,
    this.bln,
    this.thn,
  });

  Map<String, dynamic> toMap() {
    return {
      'tgl': tgl,
      'bln': bln,
      'thn': thn,
    };
  }

  factory SessionLogin.fromMap(Map<String, dynamic> map) {
    return SessionLogin(
      tgl: map['tgl'],
      bln: map['bln'],
      thn: map['thn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionLogin.fromJson(String source) =>
      SessionLogin.fromMap(json.decode(source));
}

class StoragePreferences {
  static GetStorage box = GetStorage();

  static setTimeLogin(SessionLogin value) {
    final json = value.toMap();
    final jsonString = jsonEncode(json);
    box.write("session", jsonString);
  }

  static String getTimeLogin() {
    return box.read("session") ??
        jsonEncode(SessionLogin(bln: 0, tgl: 0, thn: 0).toMap());
  }
}
