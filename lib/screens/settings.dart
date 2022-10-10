import 'dart:collection';
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
    Color tileColor = Theme.of(context).listTileTheme.tileColor!;
    return FutureBuilder(
        future: _getSettings(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Scaffold(
                  appBar: AppBar(
                    iconTheme: Theme.of(context).iconTheme,
                    actions: [
                      IconButton(
                        onPressed: () {
                          tokenNotifier!.setToken("");
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.logout),
                        color: Theme.of(context).iconTheme.color,
                      )
                    ],
                  ),
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: Theme.of(context).brightness == Brightness.dark ? const BoxDecoration(
                        gradient: RadialGradient(
                            radius: 1.5,
                            center: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(19, 49, 90, 1),
                              Color.fromRGBO(8, 26, 52, 1)
                            ]
                        )
                    ): null,
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
                              const SizedBox(height: 8,),
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
                                        changeDialog(
                                            user,
                                            "changeFullNameHint".tr(),
                                            "fullname");
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
                                          changeDialog(
                                              user, "changeemailHint", "email");
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
                                          changeDialog(
                                              user,
                                              "enterNewPassword".tr(),
                                              "password");
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
                                      color: tileColor
                                  ),
                                  child: ListTile(
                                    tileColor: tileColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    onTap: () {
                                      selectLanguageDialog(user);
                                    },
                                    title: Text("language".tr()),
                                    trailing: Icon(Icons.info_outlined,
                                        color: Theme.of(context).iconTheme.color),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: tileColor
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                        tileColor: Colors.transparent,
                                      onTap: () => selectNetworkDialog(user),
                                      title: const Text("network").tr(),
                                      trailing: const Icon(Icons.arrow_forward_ios,
                                          color: Colors.transparent,
                                    )),
                                    avaliableTypes!
                                        .contains(BiometricType.fingerprint) ||
                                        avaliableTypes!
                                            .contains(BiometricType.face) ||
                                        avaliableTypes!
                                            .contains(BiometricType.strong)
                                        ? ListTile(
                                      tileColor: Colors.transparent,
                                      title: const Text("fingerprint").tr(),
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
                                                  'fingerprintEnabled')
                                                  .tr()
                                                  : const Text(
                                                  'fingerprintDisabled')
                                                  .tr()));
                                        },
                                        value: isFingerprintLogin ?? false,
                                      ),
                                    )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: tileColor
                                ),
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
                                    value: snapshot.data ?? false,
                                  ),
                                ),
                              )
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
                  leading: context.locale == supportedLocales[index]
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink(),
                  onTap: () {
                    context.setLocale(supportedLocales[index]);
                    Navigator.of(context).pop();
                  },
                  title: Text(supportedLocales[index].languageCode.tr()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future selectNetworkDialog(User user) {
    return showDialog(
      context: context,
      builder: (context) {
        Map<String, int> supportedNetworks = HashMap();
        supportedNetworks.putIfAbsent("BSC TestNet", () => 1);
        supportedNetworks.putIfAbsent("BSC MainNet", () => 2);
        FlutterSecureStorage storage = const FlutterSecureStorage();
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                supportedNetworks.length,
                (index) => ListTile(
                  leading: user.defaultNetwork ==
                          supportedNetworks.values.toList()[index]
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink(),
                  onTap: () {
                    user.defaultNetwork =
                        (supportedNetworks.values.toList()[index]);
                    storage.write(key: "user", value: jsonEncode(user));
                    Navigator.of(context).pop();
                  },
                  title: Text(supportedNetworks.keys.toList()[index]),
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
                                    ? "Success".tr()
                                    : "Error")
                                .tr()));
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
                          }
                        }
                      }
                    },
                    child: const Text("submit").tr())
              ],
            ),
          ),
        );
      });
}
