import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenNotifier extends ChangeNotifier {
  final String key = "token";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _token = "";
  String get token => _token;
  TokenNotifier() {
    initToken();
  }

  setToken(String newToken) async {
    _token = newToken;
    await _storage.write(key: "token", value: newToken);
    newToken == ""
        ? null
        : Timer.periodic(const Duration(minutes: 10), (_) => logOut());
    notifyListeners();
  }

  initToken() async {
    _token = await _storage.read(key: "token") ?? "";
    notifyListeners();
  }

  logOut() {
    _token = "";
    notifyListeners();
    _storage.write(key: "token", value: "");
  }
}
