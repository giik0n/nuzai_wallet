import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../podo/User.dart';

Future selectLanguageDialog(User user, BuildContext context) {
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
