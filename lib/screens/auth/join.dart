import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:exomal_wallet/config/LocalAuthApi.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';
import '../../provider/TokenNotifier.dart';
import 'LoginForm.dart';
import 'RegisterForm.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
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
    List<Widget> widgets = <Widget>[const RegisterForm(), const LoginForm()];
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
                          scale: 1.5,
                        ),
                        RichText(
                          text: TextSpan(
                            style: textTheme.headline6,
                            text: "",
                            children: [
                              const TextSpan(text: "Join "),
                              TextSpan(
                                  text: "N",
                                  style:
                                      TextStyle(color: colorScheme.secondary)),
                              const TextSpan(text: "uzai wallet"),
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
                              widgets[selectedWidget],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: CupertinoButton(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context)
                                            .listTileTheme
                                            .tileColor,
                                        child: Center(
                                          child: Image.asset(
                                            'assets/icons/google.png',
                                            scale: 1.5,
                                          ),
                                        ),
                                        onPressed: () {}),
                                  ),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: CupertinoButton(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context)
                                            .listTileTheme
                                            .tileColor,
                                        child: Center(
                                          child: Image.asset(
                                            'assets/icons/facebook.png',
                                          ),
                                        ),
                                        onPressed: () {}),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  color: const Color.fromRGBO(23, 25, 46, 0.1),
                                  height: 1,
                                )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: const Text("or").tr(),
                                ),
                                Expanded(
                                    child: Container(
                                  color: const Color.fromRGBO(23, 25, 46, 0.1),
                                  height: 1,
                                )),
                              ],
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              selectedWidget != 1
                                  ? "Already have account?"
                                  : "Don't have an account yet?",
                            ).tr(),
                            TextButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.all(Colors.blue[50]),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedWidget = selectedWidget != 1 ? 1 : 0;
                                });
                              },
                              child: Text(
                                selectedWidget != 1 ? "Sign in" : "Sign up",
                                style: const TextStyle(color: Colors.blue),
                              ).tr(),
                            )
                          ],
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
}
