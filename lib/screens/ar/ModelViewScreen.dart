import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelViewScreen extends StatefulWidget {
  final String? ipfsUrl;
  ModelViewScreen(this.ipfsUrl, {Key? key}) : super(key: key);

  @override
  State<ModelViewScreen> createState() => _ModelViewScreenState();
}

class _ModelViewScreenState extends State<ModelViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ModelViewer(
          ar: true,
          src: !widget.ipfsUrl!.contains('github')
              ? 'https://github.com/KhronosGroup/glTF-Sample-Models/raw/main/2.0/Duck/glTF-Binary/Duck.glb'
              : 'assets/models/Duck.glb',
        ));
  }
}
