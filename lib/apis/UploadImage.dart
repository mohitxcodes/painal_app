import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryConfig {
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'YOUR_UPLOAD_PRESET';
  static String get apiUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}

Future<void> pickAndUploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(CloudinaryConfig.apiUrl),
    );
    request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      var jsonResponse = json.decode(respStr);
      print('-----------Upload successful: ${jsonResponse['secure_url']}');
    } else {
      print('----------Upload failed: ${response.statusCode}');
    }
  } else {
    print('No image selected.');
  }
}
