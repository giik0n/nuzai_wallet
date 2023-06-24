import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exomal_wallet/provider/MnemonicNotifier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:mnemonic/mnemonic.dart';

import '../../podo/User.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({Key? key}) : super(key: key);

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class ImportMnemonic extends StatefulWidget {
  const ImportMnemonic({super.key});
  @override
  State<ImportMnemonic> createState() => _ImportMnemonicState();
}

class _ImportMnemonicState extends State<ImportMnemonic> {
  var mnemonicPhrase = "";

  TextEditingController mnemonicPhraseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mnemonicNotifier = Provider.of<MnemonicNotifier>(context);
    mnemonicNotifier.initMnemonic();
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 48,
                width: 250,
                child: TextField(
                  controller: mnemonicPhraseController,
                  onChanged: ((value) => setState(() {
                        mnemonicPhrase = value;
                      })),
                  decoration: InputDecoration(hintText: "pasteMnemonic".tr()),
                ),
              ),
              IconButton(
                  onPressed: () => {
                        Clipboard.getData(Clipboard.kTextPlain).then((value) {
                          setState(() {
                            mnemonicPhrase = (value?.text ?? "");
                            mnemonicPhraseController.text = (value?.text ?? "");
                          });
                        })
                      },
                  icon: new Icon(Icons.paste))
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                print("saving...");
                if (validateMnemonic(mnemonicPhrase)) {
                  String? userStr = await storage.read(key: "user");
                  User user = User.fromJson(jsonDecode(userStr!));
                  await mnemonicNotifier.saveMnemonic(mnemonicPhrase, user);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Error".tr()),
                  ));
                }
              },
              child: const Text("save").tr(),
            )),
      ],
    );
  }
}

class GenerateMnemonic extends StatefulWidget {
  const GenerateMnemonic({super.key});
  @override
  State<GenerateMnemonic> createState() => _GenerateMnemonicState();
}

class _GenerateMnemonicState extends State<GenerateMnemonic> {
  String mnemonicPhrase = generateMnemonic();

  TextEditingController mnemonicPhraseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mnemonicNotifier = Provider.of<MnemonicNotifier>(context);
    mnemonicPhraseController.text = mnemonicPhrase;
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 48,
                width: 250,
                child: TextField(
                  controller: mnemonicPhraseController,
                  onChanged: ((value) => setState(() {
                        mnemonicPhrase = value;
                      })),
                  decoration: InputDecoration(hintText: "pasteMnemonic".tr()),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: mnemonicPhraseController.text));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("save".tr()),
                    ));
                  },
                  icon: new Icon(Icons.copy))
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                if (validateMnemonic(mnemonicPhrase)) {
                  String? userStr = await storage.read(key: "user");
                  print("New user string:" + (userStr ?? ""));
                  User user = User.fromJson(jsonDecode(userStr!));
                  await mnemonicNotifier.saveMnemonic(mnemonicPhrase, user);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Error".tr()),
                  ));
                }
              },
              child: const Text("save").tr(),
            )),
      ],
    );
  }
}

class _CreateWalletState extends State<CreateWallet> {
  int? selectedWidget = null;

  InputBorder inputBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      style: BorderStyle.none,
      width: 0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[ImportMnemonic(), GenerateMnemonic()];

    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    var column = Column(
      children: [
        SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  selectedWidget = 0;
                });
              },
              child: const Text("importMnemonic").tr(),
            )),
        SizedBox(
          height: 8,
        ),
        SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  selectedWidget = 1;
                });
              },
              child: const Text("createMnemonic").tr(),
            )),
      ],
    );

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
                          scale: 4,
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
                          child: selectedWidget == null
                              ? column
                              : widgets[selectedWidget!],
                        ),
                      ],
                    ),
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
