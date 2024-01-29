import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class ModelViewScreen extends StatefulWidget {
  final String? ipfsUrl;
  ModelViewScreen(this.ipfsUrl, {Key? key}) : super(key: key);

  @override
  State<ModelViewScreen> createState() => _ModelViewScreenState();
}

class _ModelViewScreenState extends State<ModelViewScreen> {
  O3DController controller = O3DController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: !widget.ipfsUrl!.contains('github')
          ? O3D.network(
              src: widget.ipfsUrl ??
                  'https://github.com/KhronosGroup/glTF-Sample-Models/raw/main/2.0/Duck/glTF-Binary/Duck.glb',
              // ...
            )
          : O3D.asset(src: 'assets/models/Duck.glb'),
    );
  }
}
