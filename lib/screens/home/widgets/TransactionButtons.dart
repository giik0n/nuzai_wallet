import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuzai_wallet/podo/User.dart';
import 'package:nuzai_wallet/screens/home/SendTokensPage.dart';

Widget getButtons(BuildContext context, User user) {
  ThemeData themeData = Theme.of(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Column(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              showModalBottomSheet<void>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(39.0),
                      topLeft: Radius.circular(39.0)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.network(
                            "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=${user.wallet!}",
                            scale: 1.1,
                          ),
                          Text(
                            'receive',
                            style: themeData.textTheme.headline5,
                          ).tr(),
                          Text(
                            'scanAddressToReceivePayment',
                            style: themeData.textTheme.bodySmall,
                          ).tr(),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: user.wallet!,
                                        style: TextStyle(
                                            color: themeData
                                                .colorScheme.secondary)),
                                  ),
                                ),
                                IconButton(
                                  onPressed: (() async {
                                    await Clipboard.setData(
                                        ClipboardData(text: user.wallet!));
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: const Text('clipboard').tr()));
                                  }),
                                  icon: const Icon(Icons.copy),
                                  color: themeData.colorScheme.secondary
                                      .withAlpha(55),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Image.asset("assets/icons/receive.png"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: const Text("receive").tr(),
          ),
        ],
      ),
      Column(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendTokensPage(user: user,)));
            },
            icon: Image.asset("assets/icons/send.png"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: const Text("send").tr(),
          ),
        ],
      ),
    ],
  );
}
