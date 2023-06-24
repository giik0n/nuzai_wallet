import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../podo/User.dart';
import '../../../provider/TokenNotifier.dart';
import 'TransactionButtons.dart';

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
              user.wallet ?? "",
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
    headerTransactionButtons(context, user),
    const SizedBox(
      height: 24.0,
    ),
  ]);
}
