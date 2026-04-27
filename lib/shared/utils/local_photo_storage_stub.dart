import 'package:image_picker/image_picker.dart';

Future<String?> persistPickedPhoto(XFile pickedFile) async => pickedFile.path;
