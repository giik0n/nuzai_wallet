import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:nuzai_wallet/podo/User.dart';
import 'package:nuzai_wallet/service/RestClient.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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
final TextEditingController codeController = TextEditingController();

final TextEditingController passController = TextEditingController();
final TextEditingController confirmPassController = TextEditingController();

String? validator;

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool codeSent = false;
  bool codeSuccess = false;
  late Form form;

  @override
  Widget build(BuildContext context) {
    if (codeSent && codeSuccess) {
      form = registerFieldsForm();
    } else if (codeSent && !codeSuccess) {
      form = verifyCodeForm();
    } else {
      form = sendCodeForm();
    }
    return form;
  }

  Form sendCodeForm() => Form(
        key: _form,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email".tr(),
                filled: true,
                enabledBorder: inputBorder,
                border: inputBorder,
                errorBorder: inputBorder,
                focusedBorder: inputBorder,
                focusedErrorBorder: inputBorder,
              ),
              validator: (value) =>
                  value!.isNotEmpty ? null : "Please enter a valid email.".tr(),
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
                        Response? response;
                        if (_form.currentState!.validate()) {
                          response =
                              await RestClient.getCode(emailController.text);
                        }
                        if (response != null && response.statusCode == 200) {
                          setState(() {
                            codeSent = true;
                          });
                        } else {
                          print(response?.statusCode);
                        }
                      },
                      child: const Text("Sign up", style: TextStyle(color: Colors.white)).tr(),
                    ))),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );

  Form verifyCodeForm() => Form(
        key: _form,
        child: Column(
          children: [
            PinCodeTextField(
              autoDisposeControllers: false,
              keyboardType: TextInputType.number,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveFillColor: Colors.transparent,
                inactiveColor: Colors.grey,
                activeFillColor:
                    Theme.of(context).inputDecorationTheme.fillColor,
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              controller: codeController,
              onCompleted: (value) {
                codeController.text = value;
              },
              onChanged: (value) {

              },
              appContext: context,

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
                        Response? response;
                        if (_form.currentState!.validate()) {
                          response = await RestClient.verifyCode(
                              emailController.text, codeController.text);
                        }
                        if (response != null && response.statusCode == 200) {
                          setState(() {
                            codeSent = true;
                            codeSuccess = true;
                          });
                        } else {
                          print(response?.statusCode);
                        }
                      },
                      child: const Text("next", style: TextStyle(color: Colors.white)).tr(),
                    ))),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );
}

Form registerFieldsForm() => Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Fullname".tr(),
              filled: true,
              enabledBorder: inputBorder,
              border: inputBorder,
              errorBorder: inputBorder,
              focusedBorder: inputBorder,
              focusedErrorBorder: inputBorder,
            ),
            validator: (value) =>
                value!.isNotEmpty ? null : "Name can't be empty".tr(),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Email".tr(),
              filled: true,
              enabledBorder: inputBorder,
              border: inputBorder,
              errorBorder: inputBorder,
              focusedBorder: inputBorder,
              focusedErrorBorder: inputBorder,
            ),
            validator: (value) => EmailValidator.validate(value!)
                ? null
                : "Please enter a valid email.".tr(),
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
            validator: (value) =>
                value!.isNotEmpty ? null : "Password can't be empty".tr(),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            obscureText: true,
            controller: confirmPassController,
            decoration: InputDecoration(
              hintText: "Repeat password".tr(),
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
                    : "Not match".tr()
                : "Password can't be empty".tr(),
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
                        response = await RestClient.register(
                            emailController.text,
                            passController.text,
                            nameController.text);
                      }
                      if (response != null && response.statusCode == 201) {
                        User user = User.fromJson(
                            json.decode(response.body)["bodyResponse"]);
                        FlutterSecureStorage storage =
                            const FlutterSecureStorage();
                        storage.write(
                            key: "email", value: emailController.text);
                        storage.write(
                            key: "password", value: passController.text);
                        await storage.write(
                            key: "user", value: jsonEncode(user));
                        notifier.setToken(user.token ?? "");
                        emailController.text = "";
                        passController.text = "";
                      } else {
                        print(response?.statusCode);
                      }
                    },
                    child: const Text("btnRegister", style: TextStyle(color: Colors.white)).tr(),
                  ))),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
