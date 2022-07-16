import 'package:flutter/material.dart';
import '../widgets/camera_preview.dart';
import '../widgets/images_gallery.dart';

class TabItem {
  String title;
  Icon icon;
  Widget page;
  TabItem({required this.title, required this.icon, required this.page});
}

final List<TabItem> tabBar = [
  TabItem(title: "Camera", icon: const Icon(Icons.camera), page: const CameraWidget(title: 'Camera preview')),
  TabItem(title: "Gallery", icon: const Icon(Icons.insert_photo), page: const GalleryWidget(title: 'Images gallery')),
];