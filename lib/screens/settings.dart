import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nuzai_wallet/config/LocalAuthApi.dart';
import 'package:nuzai_wallet/podo/User.dart';
import 'package:nuzai_wallet/provider/TokenNotifier.dart';
import 'package:nuzai_wallet/service/RestClient.dart';
import 'package:nuzai_wallet/widgets/CustomLoader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final User? user;

  const SettingsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TokenNotifier? tokenNotifier;
  bool? isNews;
  String? selectedLocale;
  bool? isFaceLogin;
  bool? isFingerprintLogin;
  List<BiometricType>? avaliableTypes;
  LocalAuthApi localAuthApi = LocalAuthApi();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    tokenNotifier = Provider.of<TokenNotifier>(context);
    User user = widget.user!;
    String settingsTitle = 'settings'.tr();
    return FutureBuilder(
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
                  body: SingleChildScrollView(
                    child: Padding(
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
                                        text: settingsTitle[0].tr(),
                                        style: TextStyle(
                                            color: colorScheme.secondary)),
                                    TextSpan(
                                        text: settingsTitle
                                            .substring(1, settingsTitle.length)),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                                onTap: () {
                                  changeDialog(user, "changeFullNameHint".tr(),
                                      "fullname");
                                },
                                title: Text("changeFullName".tr())),
                            ListTile(
                                onTap: () {
                                  changeDialog(
                                      user, "changeemailHint", "email");
                                },
                                title: Text("changeemail".tr())),
                            ListTile(
                                onTap: () {
                                  changeDialog(user, "enterNewPassword".tr(),
                                      "password");
                                },
                                title: Text("changepwd".tr())),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                onTap: () {
                                  selectLanguageDialog(user);
                                },
                                title: Text("language".tr()),
                                trailing: const Icon(
                                  Icons.info_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => changeDialog(
                                  user, "Select network", "defaultNetwork"),
                              child: const ListTile(
                                title: Text("Network"),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                ),
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
                  ),
                )
              : const Scaffold(
                  body: Center(
                    child: Text("Loading ..."),
                  ),
                );
        });
  }

  Future<bool> _getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isNews = prefs.getBool('sendNews');
    selectedLocale = prefs.getString('selectedLocale');
    isFingerprintLogin = prefs.getBool("isFingerprintLogin");
    isFaceLogin = prefs.getBool("isFaceLogin");
    avaliableTypes = await localAuthApi.getAvailableBiometrics();
    return true;
  }

  Future selectLanguageDialog(User user) {
    return showDialog(
      context: context,
      builder: (context) {
        List<Locale> supportedLocales = context.supportedLocales;
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                supportedLocales.length,
                (index) => ListTile(
                  title: Text(supportedLocales[index].languageCode.tr()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future changeDialog(User user, String hint, String key) => showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();

        switch (key) {
          case "fullname":
            controller.text = user.fullname!;
            break;
          case "email":
            controller.text = user.email!;
            break;
          case "defaultNetwork":
            controller.text = user.defaultNetwork!.toString();
            break;
        }

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: key == "defaultNetwork"
                      ? TextInputType.number
                      : TextInputType.text,
                  decoration: InputDecoration(hintText: hint),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (controller.text.isNotEmpty) {
                        showDialog(
                            // The user CANNOT close this dialog  by pressing outsite it
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              return const CustomLoader();
                            });
                        Response response = await RestClient.editUser(
                            user.token!, user.id!, key, controller.text);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response.statusCode == 200
                                ? "Changed"
                                : "Some problem")));
                        if (response.statusCode == 200) {
                          FlutterSecureStorage storage =
                              const FlutterSecureStorage();
                          switch (key) {
                            case "fullname":
                              user.fullname = controller.text;
                              storage.write(
                                  key: "user", value: jsonEncode(user));
                              break;
                            case "email":
                              user.email = controller.text;
                              storage.write(
                                  key: "user", value: jsonEncode(user));
                              break;
                            case "password":
                              storage.write(
                                  key: "password", value: controller.text);
                              break;
                            case "defaultNetwork":
                              user.defaultNetwork = int.parse(controller.text);
                              storage.write(
                                  key: "user", value: jsonEncode(user));
                              break;
                          }
                        }
                      }
                    },
                    child: const Text("Submit"))
              ],
            ),
          ),
        );
      });
}
