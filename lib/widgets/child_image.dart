import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ChildImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  const ChildImage({super.key, this.imageUrl, this.height, this.width});

  Future<bool> _checkIfFileExists(String? filePath) async {
    if (filePath == null) return false;
    File file = File(filePath);

    bool fileExists = await file.exists();

    return fileExists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _checkIfFileExists(imageUrl),
        builder: (context, isExist) {
          if (isExist.data == null) {
            return Image(
              image: MemoryImage(kTransparentImage),
              height: height,
              width: width,
              fit: BoxFit.cover,
            );
          }
          if (!isExist.data!) {
            return FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: const AssetImage("assets/images/baby_placeholder.png"),
              fit: BoxFit.cover,
              height: height,
              width: width,
              fadeInDuration: const Duration(milliseconds: 200),
              fadeOutDuration: const Duration(milliseconds: 200),
            );
          }
          return FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: FileImage(File(imageUrl!)),
            fit: BoxFit.cover,
            height: height,
            width: width,
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
          );
        });
  }
}
