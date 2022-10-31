import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nuzai_wallet/provider/TokenNotifier.dart';
import 'package:nuzai_wallet/theme/theme_constants.dart';
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
    child: const Wrapper(),
  ));
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TokenNotifier>.value(value: TokenNotifier()),
      ],
      child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Nuzai Wallet',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const MyApp()),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TokenNotifier>(
      builder: (context, TokenNotifier notifier, child) {
        return notifier.token.isNotEmpty
            ? const MyHomePage()
            : const JoinPage();
      },
    );
  }
}
