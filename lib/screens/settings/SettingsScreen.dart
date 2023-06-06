import 'package:easy_localization/easy_localization.dart';
import 'package:exomal_wallet/provider/MnemonicNotifier.dart';
import 'package:exomal_wallet/screens/settings/selectLanguageDialog.dart';
import 'package:exomal_wallet/screens/settings/selectNetworkDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:exomal_wallet/config/LocalAuthApi.dart';
import 'package:exomal_wallet/podo/User.dart';
import 'package:exomal_wallet/provider/TokenNotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'changeUserDialog.dart';

class SettingsScreen extends StatefulWidget {
  final User? user;

  const SettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TokenNotifier? tokenNotifier;
  MnemonicNotifier? mnemonicNotifier;
  bool? isNews = false;
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
    mnemonicNotifier = Provider.of<MnemonicNotifier>(context);
    User user = widget.user!;
    String settingsTitle = 'settings'.tr();
    Color tileColor = Theme.of(context).listTileTheme.tileColor!;
    return FutureBuilder(
        future: getSettings(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Scaffold(
                  appBar: AppBar(
                    iconTheme: Theme.of(context).iconTheme,
                    actions: [
                      IconButton(
                        onPressed: () async {
                          await tokenNotifier!.setToken("");
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.logout),
                        color: Theme.of(context).iconTheme.color,
                      )
                    ],
                  ),
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: Theme.of(context).brightness == Brightness.dark
                        ? const BoxDecoration(
                            gradient: RadialGradient(
                                radius: 1.5,
                                center: Alignment.bottomRight,
                                colors: [
                                Color.fromRGBO(19, 49, 90, 1),
                                Color.fromRGBO(8, 26, 52, 1)
                              ]))
                        : null,
                    child: SingleChildScrollView(
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
                                          text: settingsTitle.substring(
                                              1, settingsTitle.length)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: tileColor),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        changeUserDialog(
                                            user,
                                            "changeFullNameHint".tr(),
                                            "fullname",
                                            context);
                                      },
                                      title: Text("changeFullName".tr()),
                                      tileColor: Colors.transparent,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 0),
                                      child: Divider(
                                        height: 1,
                                      ),
                                    ),
                                    ListTile(
                                        tileColor: Colors.transparent,
                                        onTap: () {
                                          changeUserDialog(
                                              user,
                                              "changeemailHint",
                                              "email",
                                              context);
                                        },
                                        title: Text("changeemail".tr())),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 0),
                                      child: Divider(
                                        height: 1,
                                      ),
                                    ),
                                    ListTile(
                                        tileColor: Colors.transparent,
                                        onTap: () {
                                          changeUserDialog(
                                              user,
                                              "enterNewPassword".tr(),
                                              "password",
                                              context);
                                        },
                                        title: Text("changepwd".tr())),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: tileColor),
                                  child: ListTile(
                                    tileColor: tileColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    onTap: () {
                                      selectLanguageDialog(user, context);
                                    },
                                    title: Text("language".tr()),
                                    trailing: Icon(Icons.info_outlined,
                                        color:
                                            Theme.of(context).iconTheme.color),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: tileColor),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // ListTile(
                                    //     tileColor: Colors.transparent,
                                    //     onTap: () =>
                                    //         selectNetworkDialog(user, context),
                                    //     title: const Text("network").tr(),
                                    //     trailing: const Icon(
                                    //       Icons.arrow_forward_ios,
                                    //       color: Colors.transparent,
                                    //     )),
                                    avaliableTypes!.contains(
                                                BiometricType.fingerprint) ||
                                            avaliableTypes!
                                                .contains(BiometricType.face) ||
                                            avaliableTypes!
                                                .contains(BiometricType.strong)
                                        ? ListTile(
                                            tileColor: Colors.transparent,
                                            title:
                                                const Text("fingerprint").tr(),
                                            trailing: CupertinoSwitch(
                                              onChanged: (isEnabled) async {
                                                if (await LocalAuthApi
                                                    .authenticate()) {
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  await prefs.setBool(
                                                      'isFingerprintLogin',
                                                      isEnabled);
                                                  setState(() {});
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: isEnabled
                                                            ? const Text(
                                                                    'fingerprintEnabled')
                                                                .tr()
                                                            : const Text(
                                                                    'fingerprintDisabled')
                                                                .tr()));
                                              },
                                              value:
                                                  isFingerprintLogin ?? false,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: tileColor),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  title: const Text("newsletter").tr(),
                                  trailing: CupertinoSwitch(
                                    onChanged: (isNews) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool('sendNews', isNews);
                                      setState(() {});
                                    },
                                    value: isNews!,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextButton(
                                  onPressed: (() {
                                    mnemonicNotifier?.logOut(user);
                                    Navigator.pop(context);
                                  }),
                                  child: Text(
                                    "Delete wallet from device",
                                    selectionColor: Colors.red,
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ))
                            ],
                          )),
                    ),
                  ),
                )
              : Scaffold(
                  body: Center(
                    child: const Text("loading").tr(),
                  ),
                );
        });
  }

  Future<bool> getSettings() async {
    LocalAuthApi localAuthApi = LocalAuthApi();

    final prefs = await SharedPreferences.getInstance();
    isNews = prefs.getBool('sendNews') ?? false;
    selectedLocale = prefs.getString('selectedLocale') ?? 'en';
    isFingerprintLogin = prefs.getBool("isFingerprintLogin") ?? false;
    isFaceLogin = prefs.getBool("isFaceLogin") ?? false;
    avaliableTypes = await localAuthApi.getAvailableBiometrics();
    return true;
  }
}
