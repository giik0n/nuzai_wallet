import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/material.dart';



class ArCoreViewScreen extends StatefulWidget {
  const ArCoreViewScreen({Key? key}) : super(key: key);

  @override
  State<ArCoreViewScreen> createState() => _ArCoreViewScreenState();
}

class _ArCoreViewScreenState extends State<ArCoreViewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BabylonJSViewer(
        src: 'https://models.babylonjs.com/boombox.glb',
      ),
    );
  }


}
