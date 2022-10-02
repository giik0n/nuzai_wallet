import 'dart:convert';

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
  const MyHomePage({super.key, required this.title});

  final String title;

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

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            icon: const Icon(Icons.account_circle_outlined),
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
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    header(context, textTheme, colorScheme, themeData, user!),
                    Expanded(child: _tabSection(context, user!)),
                  ],
                )
              :  const SizedBox.shrink();
        }, 
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
    Text(
      'Wallet address',
      style: textTheme.subtitle1,
    ),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Copied to your clipboard !')));
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
            border:
                const Border(top: BorderSide(color: Colors.grey, width: 0.8)),
          ),
          child: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Theme.of(context).colorScheme.secondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.normal),
            indicator: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            tabs: const [
              Tab(
                text: "Tokens",
              ),
              Tab(text: "NFT's"),
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








