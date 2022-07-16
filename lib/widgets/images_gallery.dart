import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:home_module_camera_18/models/list_gallery.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> with WidgetsBindingObserver {
  late List<CameraDescription> cameras; //список доступных камер
  CameraController? controller;
  XFile? lastImage; //для отображения последнего сделанного фото на экране

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        children: listGallery
            .map(
              (item) => Container(
                height: 200,
                child: Image.file(
                  File(item),
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
