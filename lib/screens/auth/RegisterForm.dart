import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:exomal_wallet/provider/MnemonicNotifier.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:exomal_wallet/podo/User.dart';
import 'package:exomal_wallet/service/RestClient.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/TokenNotifier.dart';
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
      form = registerFieldsForm(context);
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
            Consumer<TokenNotifier>(
                builder: (context, notifier, child) => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        Response? response;
                        if (_form.currentState!.validate()) {
                          showDialog(
                              // The user CANNOT close this dialog  by pressing outsite it
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return const CustomLoader();
                              });
                          response =
                              await RestClient.getCode(emailController.text);
                          Navigator.pop(context);
                        }
                        if (response != null && response.statusCode == 200) {
                          setState(() {
                            codeSent = true;
                          });
                        } else {
                          print(response?.statusCode);
                        }
                      },
                      child: const Text("Sign up",
                              style: TextStyle(color: Colors.white))
                          .tr(),
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
                  activeFillColor: Colors.lightBlue[300],
                  activeColor: Colors.lightBlue[300]),
              animationDuration: Duration(milliseconds: 100),
              backgroundColor: Colors.transparent,
              controller: codeController,
              onCompleted: (value) {
                codeController.text = value;
              },
              onChanged: (value) => {codeController.text = value},
              appContext: context,
              validator: (value) =>
                  value!.isEmpty ? "Please enter a code.".tr() : null,
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
                          showDialog(
                              // The user CANNOT close this dialog  by pressing outsite it
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return const CustomLoader();
                              });
                          response = await RestClient.verifyCode(
                              emailController.text, codeController.text);
                          codeController.text = '';
                          Navigator.pop(context);
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
                      child: const Text("next",
                              style: TextStyle(color: Colors.white))
                          .tr(),
                    ))),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      );
}

Form registerFieldsForm(BuildContext context) {
  TokenNotifier tokenNotifier = Provider.of<TokenNotifier>(context);
  MnemonicNotifier mnemonicNotifier = Provider.of<MnemonicNotifier>(context);

  return Form(
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
          validator: (value) => value!.isNotEmpty
              ? value.contains(" ")
                  ? null
                  : "changeFullNameHint".tr()
              : "Name can't be empty".tr(),
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
        SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setBool("firstEnter", false);
                Response? response;
                if (_form.currentState!.validate()) {
                  showDialog(
                      // The user CANNOT close this dialog  by pressing outsite it
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return const CustomLoader();
                      });
                  response = await RestClient.register(emailController.text,
                      passController.text, nameController.text);

                  if (response.statusCode == 201) {
                    User user = User.fromJson(
                        json.decode(response.body)["bodyResponse"]);
                    user.wallet = "";
                    FlutterSecureStorage storage = const FlutterSecureStorage();
                    await storage.write(
                        key: "email", value: emailController.text);
                    await storage.write(
                        key: "password", value: passController.text);
                    await storage.write(key: "user", value: jsonEncode(user));
                    await tokenNotifier.setToken(user.token ?? "");
                    await mnemonicNotifier.logOut(user);
                    emailController.text = "";
                    passController.text = "";
                    confirmPassController.text = '';
                    nameController.text = "";
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    showErrorDialog(context, response.body);
                  }
                }
              },
              child: const Text("btnRegister",
                      style: TextStyle(color: Colors.white))
                  .tr(),
            )),
        const SizedBox(
          height: 8,
        ),
      ],
    ),
  );
}

Future<void> showErrorDialog(
    BuildContext context, String responseMessage) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
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
