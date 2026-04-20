import 'package:image_picker/image_picker.dart';

import 'package:supermoms/shared/utils/local_photo_storage_stub.dart'
    if (dart.library.io) 'local_photo_storage_io.dart' as storage_impl;

Future<String?> persistPickedPhoto(XFile pickedFile) =>
    storage_impl.persistPickedPhoto(pickedFile);
