import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

class ArAndroid extends StatefulWidget {
  final String? ipfsUrl;

  const ArAndroid(this.ipfsUrl, {super.key});

  @override
  State<ArAndroid> createState() => _ArAndroidState();
}

class _ArAndroidState extends State<ArAndroid> {
  ArCoreController? arCoreController;
  String? objectSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Object on plane detected'),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onPlaneTap = _handleOnPlaneTap;
  }

  void _addToucano(ArCoreHitTestResult plane) {
    if (objectSelected != null) {
      final toucanoNode = ArCoreReferenceNode(
          objectUrl: widget.ipfsUrl ??
              "https://github.com/KhronosGroup/glTF-Sample-Assets/raw/main/Models/Duck/glTF-Binary/Duck.glb",
          name: widget.ipfsUrl ??
              "https://github.com/KhronosGroup/glTF-Sample-Assets/raw/main/Models/Duck/glTF-Binary/Duck.glb",
          position: plane.pose.translation,
          rotation: plane.pose.rotation);

      arCoreController?.addArCoreNodeWithAnchor(toucanoNode);
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(content: Text('Select an object!')),
      );
    }
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addToucano(hit);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}
