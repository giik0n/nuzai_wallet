import 'dart:io';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ArIos extends StatefulWidget {
  final String? ipfsUrl;

  const ArIos(this.ipfsUrl, {super.key});

  @override
  _ArIosState createState() => _ArIosState();
}

class _ArIosState extends State<ArIos> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  List<ARKitNode> nodes = [];
  late File currentModel;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('View in AR')),
        body: ARKitSceneView(
          showFeaturePoints: false,
          enableTapRecognizer: true,
          planeDetection: ARPlaneDetection.horizontal,
          onARKitViewCreated: onARKitViewCreated,
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) async {
    this.arkitController = arkitController;
    this.arkitController.onARTap = (ar) {
      final point = ar.firstWhereOrNull(
        (o) => o.type == ARKitHitTestResultType.featurePoint,
      );
      if (point != null) {
        _onARTapHandler(point);
      }
    };
    currentModel = await _downloadFile(widget.ipfsUrl ?? '');
  }

  Future<void> onRemoveEverything() async {
    nodes.forEach((node) {
      arkitController.remove(node.name);
    });

    nodes = [];
  }

  Future<void> _onARTapHandler(ARKitTestResult point) async {
    final position = vector.Vector3(
      point.worldTransform.getColumn(3).x,
      point.worldTransform.getColumn(3).y,
      point.worldTransform.getColumn(3).z,
    );

    final node = await _getNodeFromNetwork(
        position,
        widget.ipfsUrl ??
            'https://github.com/KhronosGroup/glTF-Sample-Assets/raw/main/Models/Duck/glTF-Binary/Duck.glb');
    // final node = _getNodeFromNetwork(position);
    await onRemoveEverything();
    arkitController.add(node);
    _addLight(arkitController, position);
    nodes.add(node);
  }

  void _addLight(ARKitController controller, vector.Vector3 position) {
    final light = ARKitLight(
      type: ARKitLightType.omni,
      color: Colors.amber,
    );
    final node = ARKitNode(
        light: light,
        position: vector.Vector3(position.x, position.y + 20, position.z));
    controller.add(node);
    nodes.add(node);
  }

  Future<ARKitGltfNode> _getNodeFromNetwork(
      vector.Vector3 position, String url) async {
    final file = currentModel;
    if (file.existsSync()) {
      //Load from app document folder
      return ARKitGltfNode(
        name: url,
        assetType: AssetType.documents,
        url: file.path.split('/').last, //  filename.extension only!
        scale: vector.Vector3(1, 1, 1),
        position: position,
      );
    }
    throw Exception('Failed to load $file');
  }

  Future<File> _downloadFile(String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${url.split("/").last}';
      print(url);
      await Dio().download(url, filePath);
      final file = File(filePath);
      print('Download completed!! path = $filePath');
      return file;
    } catch (e) {
      print('Caught an exception: $e');
      rethrow;
    }
  }
}
