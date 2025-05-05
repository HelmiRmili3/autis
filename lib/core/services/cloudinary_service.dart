import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryRestService {
  static const String _baseUrl = 'https://api.cloudinary.com/v1_1';

  final String _cloudName = dotenv.get('CLOUDINARY_CLOUD_NAME');
  final String _apiKey = dotenv.get('CLOUDINARY_API_KEY');
  final String _apiSecret = dotenv.get('CLOUDINARY_API_SECRET');
  final String _uploadPreset = dotenv.get('CLOUDINARY_UPLOAD_PRESET');

  // CLOUDINARY_UPLOAD_PRESET=autis_storage

  Future<Map<String, dynamic>> uploadVideo(File videoFile) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    const folder = 'autis';

    // Parameters must be alphabetically sorted
    final params = {
      'folder': folder,
      'timestamp': timestamp,
      'upload_preset': _uploadPreset,
    };

    final signature = _generateSignature(params);

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/video/upload',
    );

    final request = http.MultipartRequest('POST', url)
      ..fields.addAll({
        ...params,
        'signature': signature,
        'api_key': _apiKey,
      })
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        videoFile.path,
      ));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseData);
    } else {
      throw Exception('Upload failed: ${response.statusCode} - $responseData');
    }
  }

  String _generateSignature(Map<String, String> params) {
    // 1. Sort parameters alphabetically
    final sortedKeys = params.keys.toList()..sort();

    // 2. Create string to sign
    final stringToSign =
        sortedKeys.map((key) => '$key=${params[key]}').join('&');

    // 3. Append API secret and hash
    final signatureString = '$stringToSign$_apiSecret';
    return sha1.convert(utf8.encode(signatureString)).toString();
  }

  // Alternative method for uploading from URL (as shown in docs)
  Future<Map<String, dynamic>> uploadVideoFromUrl({
    required String videoUrl,
    String? publicId,
    String folder = 'autism_videos',
  }) async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/video/upload'
        '?file=$videoUrl'
        '&upload_preset=autis_storage'
        '&api_key=$_apiKey'
        '&folder=$folder'
        '${publicId != null ? '&public_id=$publicId' : ''}',
      );

      final response = await http.post(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
            'Upload failed: ${response.statusCode} - ${data['error']['message']}');
      }
    } catch (e) {
      throw Exception('Upload error: ${e.toString()}');
    }
  }

  /// Uploads a file to Cloudinary using REST API
  Future<Map<String, dynamic>> uploadFile({
    required String filePath,
    required String folder,
    String? publicId,
  }) async {
    final url = Uri.parse('$_baseUrl/$_cloudName/image/upload');
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Prepare the request
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'your_upload_preset' // Required if unsigned
      ..fields['folder'] = folder
      ..fields['timestamp'] = timestamp
      ..fields['api_key'] = _apiKey;

    // Add signature if needed (signed upload)
    if (_apiSecret.isNotEmpty) {
      final params = {
        'folder': folder,
        'timestamp': timestamp,
        'api_key': _apiKey,
      };
      final signature = _generateSignature(params);
      request.fields['signature'] = signature;
    }

    // Attach the file
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    // Send the request
    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseData);
    } else {
      throw Exception('Upload failed: ${response.reasonPhrase}');
    }
  }

  /// Deletes a file using public_id
  Future<void> deleteFile(String publicId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final params = {
      'public_id': publicId,
      'timestamp': timestamp,
      'api_key': _apiKey,
    };
    final signature = _generateSignature(params);

    final url = Uri.parse('$_baseUrl/$_cloudName/image/destroy').replace(
      queryParameters: {
        ...params,
        'signature': signature,
      },
    );

    final response = await http.post(url);
    if (response.statusCode != 200) {
      throw Exception('Deletion failed: ${response.body}');
    }
  }
}
