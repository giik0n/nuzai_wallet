import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    List<BiometricType> biometrics = await getAvailableBiometrics();
    bool onlyBio = biometrics.contains(BiometricType.face) ||
        biometrics.contains(BiometricType.face);
    try {
      return await _auth.authenticate(
          localizedReason: "Scan biometric to auth",
          options: AuthenticationOptions(
              stickyAuth: true, useErrorDialogs: true, biometricOnly: onlyBio));
    } on PlatformException catch (error) {
      print(error.stacktrace);
      return false;
    }
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;

      if (await isDeviceSupported() || canAuthenticateWithBiometrics) {
        return await _auth.getAvailableBiometrics();
      } else {
        return [];
      }
    } on PlatformException catch (e) {
      print(e);
      return <BiometricType>[];
    }
  }

  static Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
