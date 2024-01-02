import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:exomal_wallet/provider/MnemonicNotifier.dart';
import 'package:exomal_wallet/provider/TokenNotifier.dart';
import 'package:exomal_wallet/screens/auth/CreateWallet.dart';
import 'package:exomal_wallet/theme/theme_constants.dart';
import 'package:provider/provider.dart';

import 'config/LocalAuthApi.dart';
import 'screens/auth/join.dart';
import 'screens/home/MyHomePage.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    print(await ArCoreController.checkArCoreAvailability());
    print('\nAR SERVICES INSTALLED?');
    print(await ArCoreController.checkIsArCoreInstalled());
  }

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
            value: MnemonicNotifier())
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
    LocalAuthApi localAuthApi = new LocalAuthApi();
    return FutureBuilder(
        future: localAuthApi.getAvailableBiometrics(),
        builder: (context, snapshot) {
          return Consumer<TokenNotifier>(
            builder: (context, TokenNotifier notifier, child) {
              return notifier.token.isNotEmpty
                  ? Consumer<MnemonicNotifier>(builder:
                      (context, MnemonicNotifier mnemonicNotifier, child) {
                      print("Mnemonic:" +
                          (!mnemonicNotifier.mnemonic.isEmpty).toString());
                      return mnemonicNotifier.mnemonic.isEmpty
                          ? CreateWallet()
                          : (snapshot.data != null && snapshot.data!.length > 0
                              ? FutureBuilder(
                                  future: LocalAuthApi.authenticate(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data == true) {
                                        return MyHomePage();
                                      } else {
                                        return CreateWallet();
                                      }
                                    }
                                    return SizedBox.shrink();
                                  }))
                              : MyHomePage());
                    })
                  : const JoinPage();
            },
          );
        });
  }
}
