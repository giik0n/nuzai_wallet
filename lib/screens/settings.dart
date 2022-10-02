import 'dart:collection';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nuzai_wallet/config/LocalAuthApi.dart';
import 'package:nuzai_wallet/provider/TokenNotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TokenNotifier? tokenNotifier;
  bool? isNews;
  bool? isFaceLogin;
  bool? isFingerprintLogin;
  List<BiometricType>? avaliableTypes;
  LocalAuthApi localAuthApi = LocalAuthApi();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    tokenNotifier = Provider.of<TokenNotifier>(context);

    return Consumer<TokenNotifier>(
      builder: (context, TokenNotifier notifier, child) => FutureBuilder(
          future: _getSettings(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                            onPressed: () {
                              tokenNotifier!.setToken("");
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.logout))
                      ],
                    ),
                    body: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: textTheme.headline4,
                                  text: "",
                                  children: [
                                    TextSpan(
                                        text: "S",
                                        style: TextStyle(
                                            color: colorScheme.secondary)),
                                    const TextSpan(text: "ettings"),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                                onTap: () {},
                                title: const Text("Change FullName")),
                            ListTile(
                                onTap: () {},
                                title: const Text("Change E-mail")),
                            ListTile(
                                onTap: () {},
                                title: const Text("Change Password")),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text("Language"),
                                trailing: Icon(
                                  Icons.info_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const ListTile(
                              title: Text("Network"),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ),
                            avaliableTypes!.contains(BiometricType.face)
                                ? ListTile(
                                    title: const Text("Face Login"),
                                    trailing: CupertinoSwitch(
                                      onChanged: (isEnabled) async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        await prefs.setBool(
                                            'isFaceLogin', isEnabled);
                                        setState(() {});
                                      },
                                      value: isFaceLogin ?? false,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            avaliableTypes!
                                        .contains(BiometricType.fingerprint) ||
                                    avaliableTypes!
                                        .contains(BiometricType.strong)
                                ? ListTile(
                                    title: const Text("Fingerprint Login"),
                                    trailing: CupertinoSwitch(
                                      onChanged: (isEnabled) async {
                                        if (await LocalAuthApi.authenticate()) {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setBool(
                                              'isFingerprintLogin', isEnabled);
                                          setState(() {});
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: isEnabled
                                                    ? const Text(
                                                        'Fingerprint Login enabled!')
                                                    : const Text(
                                                        'Fingerprint Login disabled!')));
                                      },
                                      value: isFingerprintLogin ?? false,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            ListTile(
                              title: const Text("Newsletter"),
                              trailing: CupertinoSwitch(
                                onChanged: (isNews) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('sendNews', isNews);
                                  setState(() {});
                                },
                                value: snapshot.data ?? false,
                              ),
                            )
                          ],
                        )),
                  )
                : const Scaffold(
                    body: Center(
                      child: Text("Loading ..."),
                    ),
                  );
          }),
    );
  }

  Future<bool> _getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isNews = prefs.getBool('sendNews');
    isFingerprintLogin = prefs.getBool("isFingerprintLogin");
    isFaceLogin = prefs.getBool("isFaceLogin");
    avaliableTypes = await localAuthApi.getAvailableBiometrics();
    print(avaliableTypes.toString());
    return true;
  }
}
