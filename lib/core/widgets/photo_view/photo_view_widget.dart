import 'dart:io';

import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class PhotoViewWidget extends StatelessWidget {
  String imagePath;
  PhotoViewWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: FileImage(File(imagePath)),
    ));
  }
}
