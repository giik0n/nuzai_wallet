import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nuzai_wallet/widgets/CustomLoader.dart';

Widget emptyList(String type, BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const CustomLoader(),
      const SizedBox(height: 24),
      Text(type == "NFTs" ? "noNFTsYet": "noTokensYet").tr(),
      Text("learnMore",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary)).tr(),
      const SizedBox(height: 24),
      type == "NFTs"
          ? Column(
        children: [
          const Text("dontSeeNFTS").tr(),
          Text("importNFT",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary)).tr()
        ],
      )
          : const SizedBox.shrink(),
    ],
  );
}