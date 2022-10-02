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
      Text("No $type yet"),
      Text("Learn more",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
      const SizedBox(height: 24),
      type == "NFTs"
          ? Column(
        children: [
          Text("Don't see your $type?"),
          Text("Import NFTs",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary))
        ],
      )
          : const SizedBox.shrink(),
    ],
  );
}