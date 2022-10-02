import 'dart:collection';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:nuzai_wallet/config/LocalAuthApi.dart';
import 'package:nuzai_wallet/provider/TokenNotifier.dart';
import 'package:nuzai_wallet/service/RestClient.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../podo/User.dart';

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
    return FutureBuilder(
      future: !isScanned ? _getBiometricLogin() : getScanned(),
      builder: (context, snapshot) {
        isBiometricLoginEnabled = snapshot.data ?? false;
        return isBiometricLoginEnabled
            ? TextButton(
                onPressed: () async {
                  if (await LocalAuthApi.authenticate()) {
                    FlutterSecureStorage storage = const FlutterSecureStorage();
                    emailController.text =
                        await storage.read(key: "email") ?? "";
                    passController.text =
                        await storage.read(key: "password") ?? "";
                    setState(() {
                      isScanned = true;
                    });
                  }
                },
                child: const Text("Scan to login"))
            : Form(
                key: _form,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        fillColor: const Color.fromRGBO(245, 244, 248, 1),
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
                            : "Please enter a valid email.";
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
                        hintText: 'Password',
                        fillColor: const Color.fromRGBO(245, 244, 248, 1),
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
                            : "Password can't be empty";
                        return validator;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Consumer<TokenNotifier>(
                      builder: (context, notifier, child) => SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              http.Response? response;
                              if (validator == null) {
                                response = await RestClient.auth(emailController.text, passController.text);
                              }
                              if (response != null &&
                                  response.statusCode == 200) {
                                User user = User.fromJson(
                                    json.decode(response.body)["bodyResponse"]);
                                FlutterSecureStorage storage =
                                    const FlutterSecureStorage();
                                storage.write(
                                    key: "email", value: emailController.text);
                                storage.write(
                                    key: "password",
                                    value: passController.text);
                                await storage.write(
                                    key: "user", value: jsonEncode(user));
                                notifier.setToken(user.token ?? "");
                                emailController.text = "";
                                passController.text = "";
                              } else {
                                print(response?.statusCode);
                              }
                            },
                            child: const Text("Sign In"),
                          )),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              );
      },
    );
  }

  Future<bool> _getBiometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isFingerprintLogin = prefs.getBool("isFingerprintLogin");
    bool? isFaceLogin = prefs.getBool("isFaceLogin");
    return ((isFaceLogin ?? false) || (isFingerprintLogin ?? false));
  }

  Future<bool> getScanned() async {
    return false;
  }
}
