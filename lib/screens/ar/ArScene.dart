import 'package:exomal_wallet/screens/ar/ArAndroid.dart';
import 'package:exomal_wallet/screens/ar/ArCoreViewScreen.dart';
import 'package:exomal_wallet/screens/ar/ArIos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ArSceneProvider extends StatefulWidget {
  final String? ipfsUrl;
  const ArSceneProvider(this.ipfsUrl, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ArSceneProviderState();
  }
}

class ArSceneProviderState extends State<ArSceneProvider> {
  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.android
        ? ArCoreViewScreen(widget.ipfsUrl)
        : ArIos(widget.ipfsUrl);
  }
}
