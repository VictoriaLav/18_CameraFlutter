import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../models/list_gallery.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> with WidgetsBindingObserver {
  late List<CameraDescription> cameras;
  CameraController? controller;
  XFile? lastImage;

  @override
  void initState() {
    super.initState();
    unawaited(initCamera());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _onNewCameraSelected(cameraController.description);
    }
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: controller?.value.isInitialized == true
          ? Center(child: CameraPreview(controller!))
          : const SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var image = controller?.takePicture();
          lastImage = await image;
          image?.then((XFile? file) {
            if (mounted && file != null) {
              showInSnackBar('Picture saved to ${file.path}');
            }
          });
          setState(() {
            if (lastImage != null) {
              listGallery.add(lastImage!.path);
            }
          });
        },
        tooltip: 'Camera',
        child: const Icon(Icons.camera),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
