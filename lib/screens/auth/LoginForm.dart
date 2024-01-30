import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:exomal_wallet/screens/auth/ResetPasswordScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:exomal_wallet/config/LocalAuthApi.dart';
import 'package:exomal_wallet/provider/TokenNotifier.dart';
import 'package:exomal_wallet/service/RestClient.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../podo/User.dart';
import '../../widgets/CustomLoader.dart';

InputBorder inputBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.transparent,
    style: BorderStyle.none,
    width: 0,
  ),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

final GlobalKey<FormState> _form = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();
TextEditingController passController = TextEditingController();

String? validator;

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isBiometricLoginEnabled = false;
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<TokenNotifier>(
      builder: (context, notifier, child) => FutureBuilder(
        future: !isScanned ? _getBiometricLogin() : Future(() => false),
        builder: (context, snapshot) {
          isBiometricLoginEnabled = snapshot.data ?? false;
          return isBiometricLoginEnabled
              ? Column(
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (await LocalAuthApi.authenticate()) {
                            FlutterSecureStorage storage =
                                const FlutterSecureStorage();
                            emailController.text =
                                await storage.read(key: "email") ?? "";
                            passController.text =
                                await storage.read(key: "password") ?? "";
                            await login(notifier);
                            if (mounted) {
                              setState(() {
                                isScanned = true;
                              });
                            }
                          }
                        },
                        child: const Text("Scan to login").tr()),
                    const Text("or").tr(),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isScanned = true;
                          });
                        },
                        child: const Text("Login manually").tr()),
                  ],
                )
              : Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Email".tr(),
                          filled: true,
                          enabledBorder: inputBorder,
                          border: inputBorder,
                          errorBorder: inputBorder,
                          focusedBorder: inputBorder,
                          focusedErrorBorder: inputBorder,
                        ),
                        validator: (value) {
                          validator = EmailValidator.validate(value!)
                              ? null
                              : "Please enter a valid email.".tr();
                          return validator;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passController,
                        decoration: InputDecoration(
                          hintText: "Password".tr(),
                          filled: true,
                          enabledBorder: inputBorder,
                          border: inputBorder,
                          errorBorder: inputBorder,
                          focusedBorder: inputBorder,
                          focusedErrorBorder: inputBorder,
                        ),
                        validator: (value) {
                          validator = value!.isNotEmpty
                              ? null
                              : "Password can't be empty".tr();
                          return validator;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ResetPasswordScreen(emailController.text))),
                        child: Text(
                          style: textTheme.bodySmall,
                          "Forgot password?".tr(),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_form.currentState!.validate() || false) {
                                loginForm(notifier);
                              }
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(color: colorScheme.onPrimary),
                            ).tr(),
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Future<bool> _getBiometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isFingerprintLogin = prefs.getBool("isFingerprintLogin");
    bool? isFaceLogin = prefs.getBool("isFaceLogin");
    return ((isFaceLogin ?? false) || (isFingerprintLogin ?? false));
  }

  Future<void> login(TokenNotifier notifier) async {
    http.Response? response;
    response = await RestClient.auth(emailController.text, passController.text);
    checkResponse(response, notifier);
  }

  Future<void> loginForm(TokenNotifier notifier) async {
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const CustomLoader();
        });
    http.Response? response;
    if (_form.currentState!.validate()) {
      response =
          await RestClient.auth(emailController.text, passController.text);
    }
    if (response != null) {
      Navigator.pop(context);
      checkResponse(response, notifier);
    }
  }

  void checkResponse(http.Response response, TokenNotifier notifier) async {
    if (response.statusCode == 200) {
      FlutterSecureStorage storage = const FlutterSecureStorage();

      User user = User.fromJson(json.decode(response.body)["bodyResponse"]);
      await storage.write(key: "user", value: jsonEncode(user));

      print(user.toJson());
      storage.write(key: "email", value: emailController.text);
      storage.write(key: "password", value: passController.text);

      notifier.setToken(user.token ?? "");
      emailController.text = "";
      passController.text = "";
    } else {
      showErrorDialog(context, response.statusCode.toString());
    }
  }
}

Future<void> showErrorDialog(BuildContext context, String responseMessage,
    [String? title]) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(responseMessage),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
