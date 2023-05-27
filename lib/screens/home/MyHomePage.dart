import 'dart:convert';

import 'package:exomal_wallet/screens/home/widgets/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../podo/User.dart';
import '../settings/SettingsScreen.dart';
import 'MainHomeScreen.dart';
import 'MarketplaceScreen.dart';
import 'MetamaskScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user;

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ThemeData themeData = Theme.of(context);
    FlutterSecureStorage storage = const FlutterSecureStorage();

    return Container(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                              user: user,
                            )));
                String? userStr = await storage.read(key: "user");
                user = User.fromJson(jsonDecode(userStr!));
                if (mounted) {
                  setState(() {});
                }
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
            List<Widget> screens = [
              MainMarketplaceScreen(),
              MainHomeScreen(
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                  themeData: themeData,
                  user: user),
              MainMetamaskScreen()
            ];
            return snapshot.hasData
                ? Container(
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
                    child: screens[_selectedIndex])
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
