import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MnemonicNotifier extends ChangeNotifier {
  final String key = "mnemonic";
  String _token = "";
  String get token => _token;
  TokenNotifier() {
    initMnemonic();
  }

  saveMnemonic(String token) {
    _token = token;
    FlutterSecureStorage().write(key: key, value: token);
    print("Mnemonic saved");
    notifyListeners();
  }

  initMnemonic() async {
    _token = await FlutterSecureStorage().read(key: key) ?? "";
    notifyListeners();
  }
}
