import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:exomal_wallet/provider/MnemonicNotifier.dart';
import 'package:exomal_wallet/provider/TokenNotifier.dart';
import 'package:exomal_wallet/screens/auth/CreateWallet.dart';
import 'package:exomal_wallet/theme/theme_constants.dart';
import 'package:exomal_wallet/provider/TokenNotifier.dart';
import 'package:exomal_wallet/screens/ar/ArCoreViewScreen.dart';
import 'package:exomal_wallet/theme/theme_constants.dart';
import 'package:provider/provider.dart';

import 'screens/auth/join.dart';
import 'screens/home/MyHomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ru')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: Wrapper(),
  ));
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TokenNotifier>.value(value: TokenNotifier()),
        ChangeNotifierProvider<MnemonicNotifier>.value(
            value: MnemonicNotifier()),
      ],
      child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Exomal Wallet',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: MyApp()),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TokenNotifier>(
      builder: (context, TokenNotifier notifier, child) {
        return notifier.token.isNotEmpty
            ? Consumer<MnemonicNotifier>(
                builder: (context, MnemonicNotifier mnemonicNotifier, child) {
                print(
                    "Mnemonic:" + (!mnemonicNotifier.token.isEmpty).toString());
                return mnemonicNotifier.token.isEmpty
                    ? CreateWallet()
                    : MyHomePage();
              })
            : const JoinPage();
      },
    );
  }
}
