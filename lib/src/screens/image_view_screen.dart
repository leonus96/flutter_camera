import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  ImageViewScreen({this.imageFile});
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: FileImage(imageFile),
      ),
    );
  }
}
