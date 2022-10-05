import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:nuzai_wallet/podo/User.dart';
import 'package:nuzai_wallet/service/RestClient.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/TokenNotifier.dart';

InputBorder inputBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.transparent,
    style: BorderStyle.none,
    width: 0,
  ),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

final GlobalKey<FormState> _form = GlobalKey<FormState>();

final TextEditingController emailController = TextEditingController();
final TextEditingController nameController = TextEditingController();

final TextEditingController passController = TextEditingController();
final TextEditingController confirmPassController = TextEditingController();

String? validator;

Widget registerForm() {
  return Form(
    key: _form,
    child: Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Fullname',
            fillColor: const Color.fromRGBO(245, 244, 248, 1),
            filled: true,
            enabledBorder: inputBorder,
            border: inputBorder,
            errorBorder: inputBorder,
            focusedBorder: inputBorder,
            focusedErrorBorder: inputBorder,
          ),
          validator: (value) =>
              value!.isNotEmpty ? null : "Name can't be empty",
        ),
        const SizedBox(
          height: 8,
        ),
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
          validator: (value) => EmailValidator.validate(value!)
              ? null
              : "Please enter a valid email.",
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
          validator: (value) =>
              value!.isNotEmpty ? null : "Password can't be empty",
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: true,
          controller: confirmPassController,
          decoration: InputDecoration(
            hintText: 'Repeat password',
            fillColor: const Color.fromRGBO(245, 244, 248, 1),
            filled: true,
            enabledBorder: inputBorder,
            border: inputBorder,
            errorBorder: inputBorder,
            focusedBorder: inputBorder,
            focusedErrorBorder: inputBorder,
          ),
          validator: (value) => value!.isNotEmpty
              ? value == passController.text
                  ? null
                  : "Not match"
              : "Password can't be empty",
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
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.setBool("firstEnter", false);
                    Response? response;
                    if (_form.currentState!.validate()) {
                      response = await RestClient.register(emailController.text, passController.text, nameController.text);
                    }
                    if (response != null &&
                        response.statusCode == 201) {
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
                  child: Text("Sign Up"),
                ))),
        const SizedBox(
          height: 8,
        ),
      ],
    ),
  );
}
