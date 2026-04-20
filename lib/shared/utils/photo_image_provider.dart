import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:supermoms/shared/utils/photo_image_provider_stub.dart'
    if (dart.library.io) 'photo_image_provider_io.dart' as photo_io;

ImageProvider<Object>? buildPhotoImageProvider(String? rawPath) {
  if (rawPath == null || rawPath.trim().isEmpty) return null;

  final path = rawPath.trim();
  final isRemote =
      path.startsWith('http://') || path.startsWith('https://') || path.startsWith('data:image');

  if (isRemote || kIsWeb) {
    return NetworkImage(path);
  }

  return photo_io.buildFileImageProvider(path);
}
