import 'package:flutter/material.dart';
import 'package:nuzai_wallet/provider/TokenNotifier.dart';
import 'package:nuzai_wallet/theme/theme_constants.dart';
import 'package:provider/provider.dart';

import 'screens/auth/join.dart';
import 'screens/home/MyHomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Wrapper());
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
            ? const MyHomePage(title: 'Nuzia Wallet')
            : const JoinPage();
      },
    );
  }
}


