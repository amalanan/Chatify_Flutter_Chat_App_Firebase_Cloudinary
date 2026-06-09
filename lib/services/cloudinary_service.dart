import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class CloudinaryService {
  final String cloudName = "dnpbqxnjc";
  final String uploadPreset = "ymq2ugc1";

  Future<String?> uploadImage(PlatformFile file) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest("POST", url);

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(await http.MultipartFile.fromPath('file', file.path!));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();

        final imageUrl = RegExp(
          r'"secure_url":"(.*?)"',
        ).firstMatch(resStr)?.group(1);

        return imageUrl;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
