import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryConfig {
  static String get cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get uploadPreset =>
      dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
  static String get apiUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}
