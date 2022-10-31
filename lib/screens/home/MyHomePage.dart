import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nuzai_wallet/screens/home/widgets/EmptyListWidget.dart';
import 'package:nuzai_wallet/screens/home/widgets/NftsGridWidger.dart';
import 'package:nuzai_wallet/screens/home/widgets/TokenListWidget.dart';
import 'package:nuzai_wallet/screens/home/widgets/TransactionButtons.dart';
import 'package:provider/provider.dart';

import '../../podo/User.dart';
import '../../provider/TokenNotifier.dart';
import '../profile.dart';
import '../settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ThemeData themeData = Theme.of(context);
    FlutterSecureStorage storage = const FlutterSecureStorage();

    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              user: user,
                            )));
                String? userStr = await storage.read(key: "user");
                user = User.fromJson(jsonDecode(userStr!));
                setState(() {

                });
              },
              icon: Image.asset("assets/icons/settings.png",
                  scale: 2.5,
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
          ],
        ),
        body: FutureBuilder(
          future: storage.read(key: "user"),
          builder: (builder, snapshot) {
            if (snapshot.data != null) {
              user = User.fromJson(jsonDecode(snapshot.data!));
            }
            return snapshot.hasData
                ? Container(
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        header(context, textTheme, colorScheme, themeData, user!),
                        Expanded(child: _tabSection(context, user!)),
                      ],
                    ),
                )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

Widget header(
    BuildContext context, textTheme, colorScheme, themeData, User user) {
  String userName = user.fullname!;
  String name = userName.split(" ")[0];
  String nameFirst = name[0].toUpperCase();
  String nameRest = name.substring(1, name.length);
  String surname = userName.split(" ")[1];
  String surnameFirst = surname[0].toUpperCase();
  String surnameRest = surname.substring(1, surname.length);
  return Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(nameFirst,
            style: TextStyle(color: colorScheme.secondary, fontSize: 36)),
        Text(nameRest, style: const TextStyle(fontSize: 36)),
        Text(" $surnameFirst",
            style: TextStyle(color: colorScheme.secondary, fontSize: 36)),
        Text(surnameRest, style: const TextStyle(fontSize: 36)),
      ],
    ),
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(user.totalAmount??"0.00",),
        const Text("\$",),
      ],
    ),
    Text(
      'walletAddress',
      style: textTheme.subtitle1,
    ).tr(),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              user.wallet!,
              style: TextStyle(color: colorScheme.secondary),
            ),
            Consumer<TokenNotifier>(
              builder: (context, notifier, child) => IconButton(
                onPressed: (() async {
                  await Clipboard.setData(ClipboardData(text: user.wallet!));
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('clipboard').tr()));
                }),
                icon: const Icon(Icons.copy),
                color: themeData.colorScheme.secondary.withAlpha(55),
              ),
            )
          ],
        ),
      ),
    ),
    getButtons(context, user),
    const SizedBox(
      height: 24.0,
    ),
  ]);
}

Widget _tabSection(BuildContext context, User user) {
  return DefaultTabController(
    length: 2,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            //This is for background color
            color: Colors.white.withOpacity(0.0),
            //This is for bottom border that is needed
            border: Border(
                top: BorderSide(
                    color: Theme.of(context).textTheme.bodyText1!.color!,
                    width: 0.8)),
          ),
          child: TabBar(
            unselectedLabelColor: Theme.of(context).textTheme.subtitle2?.color,
            labelColor: Theme.of(context).colorScheme.secondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.normal),
            indicator: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            tabs: [
              Tab(
                text: "tokens".tr(),
              ),
              Tab(text: "nfts".tr()),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              children: [
                tokensList(context, user),
                nftGrid(context, user),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
