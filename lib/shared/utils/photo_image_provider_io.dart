import 'dart:io';

import 'package:flutter/widgets.dart';

ImageProvider<Object>? buildFileImageProvider(String path) {
  final file = File(path);
  if (!file.existsSync()) return null;
  return FileImage(file);
}
