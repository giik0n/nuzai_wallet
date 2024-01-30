import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:exomal_wallet/screens/auth/LoginForm.dart';
import 'package:exomal_wallet/service/RestClient.dart';
import 'package:exomal_wallet/widgets/CustomLoader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final GlobalKey<FormState> _form = GlobalKey<FormState>();

TextEditingController passController = TextEditingController();
late TextEditingController emailController;
String? validator;

class ResetPasswordScreen extends StatefulWidget {
  final String? email;
  const ResetPasswordScreen(
    this.email, {
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  int selectedWidget = 1;

  InputBorder inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      style: BorderStyle.none,
      width: 0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  @override
  Widget build(BuildContext context) {
    emailController = TextEditingController(text: widget.email);

    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: Theme.of(context).brightness == Brightness.dark
              ? const BoxDecoration(
                  gradient: RadialGradient(
                      radius: 2,
                      center: Alignment.topLeft,
                      colors: [
                      Color.fromRGBO(9, 35, 72, 0.5),
                      Color.fromRGBO(2, 14, 33, 1)
                    ]))
              : null,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/Logo.png',
                          scale: 3,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            style: textTheme.headline6,
                            text: "",
                            children: [
                              const TextSpan(text: "Join "),
                              TextSpan(
                                  text: "E",
                                  style:
                                      TextStyle(color: colorScheme.secondary)),
                              const TextSpan(text: "xomal wallet"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 8),
                          child: Column(
                            children: [
                              Form(
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
                                        validator =
                                            EmailValidator.validate(value!)
                                                ? null
                                                : "Please enter a valid email."
                                                    .tr();
                                        return validator;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_form.currentState!
                                                    .validate() ||
                                                false) {
                                              resetPassword();
                                            }
                                          },
                                          child: Text(
                                            "Reset password".tr(),
                                            style: TextStyle(
                                                color: colorScheme.onPrimary),
                                          ).tr(),
                                        )),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodySmall,
                    text: "",
                    children: [
                      TextSpan(text: "By signing up, you agree to ".tr()),
                      TextSpan(
                          text: "Terms of Service ".tr(),
                          style: TextStyle(color: colorScheme.secondary)),
                      TextSpan(text: "and confirm that our ".tr()),
                      TextSpan(
                          text: "Privacy Policy ".tr(),
                          style: TextStyle(color: colorScheme.secondary)),
                      TextSpan(text: "applies to you".tr()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const CustomLoader();
        });
    http.Response? response;
    if (_form.currentState!.validate()) {
      response = await RestClient.resetPassword(emailController.text);
    }
    if (response != null) {
      Navigator.pop(context);
      checkResponse(response);
    }
  }

  void checkResponse(http.Response response) async {
    if (response.statusCode == 200) {
      await showErrorDialog(
          context, 'Password was successfully reseted', 'Reset password');
      Navigator.pop(context);
    } else {
      showErrorDialog(context, response.statusCode.toString());
    }
  }
}
