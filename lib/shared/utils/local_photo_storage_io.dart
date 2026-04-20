import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> persistPickedPhoto(XFile pickedFile) async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final photoDir = Directory('${appDir.path}/item_photos');
    if (!photoDir.existsSync()) {
      await photoDir.create(recursive: true);
    }

    final sourcePath = pickedFile.path;
    final extension =
        sourcePath.contains('.') ? sourcePath.substring(sourcePath.lastIndexOf('.')) : '.jpg';
    final outputPath = '${photoDir.path}/item_${DateTime.now().millisecondsSinceEpoch}$extension';

    final copied = await File(sourcePath).copy(outputPath);
    return copied.path;
  } catch (_) {
    return null;
  }
}
