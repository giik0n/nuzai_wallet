import 'dart:convert';

import 'package:exomal_wallet/service/RPCService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../podo/User.dart';

class MnemonicNotifier extends ChangeNotifier {
  final String key = "mnemonic";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _mnemonic = "";
  String get mnemonic => _mnemonic;
  MnemonicNotifier() {
    initMnemonic();
  }

  saveMnemonic(String token, User user) async {
    _mnemonic = token;
    await _storage.write(key: key + (user.email ?? ""), value: token);
    user.wallet = await RPCService.getMyAddressHex(user.email ?? "");
    _storage.write(key: "user", value: jsonEncode(user));
    notifyListeners();
    print(user);
    print("saved mnemonic");
  }

  initMnemonic() async {
    print("Init mnemonic");
    String? email = await FlutterSecureStorage().read(key: "email");

    if (email != null) {
      _mnemonic = await _storage.read(key: key + (email)) ?? "";
      notifyListeners();
    }
  }

  logOut(User user) {
    _mnemonic = "";
    saveMnemonic("", user);
    notifyListeners();
  }
}
