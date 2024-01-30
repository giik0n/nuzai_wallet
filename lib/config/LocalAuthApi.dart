import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
          localizedReason: "Scan biometric to auth",
          options: const AuthenticationOptions(
              stickyAuth: true, useErrorDialogs: true));
    } on PlatformException catch (error) {
      print(error.stacktrace);
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      if (await isDeviceSupported()) {
        return await _auth.getAvailableBiometrics();
      } else {
        return [];
      }
    } on PlatformException catch (e) {
      print(e);
      return <BiometricType>[];
    }
  }

  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
