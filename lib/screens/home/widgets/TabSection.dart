import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../podo/User.dart';
import 'NftsGridWidger.dart';
import 'TokenListWidget.dart';

Widget tabSection(BuildContext context, User user) {
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
