import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:io';

class ImageApiClient {
  // API url
  final String baseUrl = 'http://10.0.2.2:8080';

  // HTTP client
  final http.Client httpClient = http.Client();

  // View images
  Future<List<dynamic>> getImages() async {
    final url = '$baseUrl/images/all';
    final response = await httpClient.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final dynamicList = jsonDecode(response.body);
      List<dynamic> imageUrls = dynamicList.map((e) => e.toString()).toList();
      return imageUrls;
    } else {
      throw Exception('Failed to load images');
    }
  }

  // Upload image
  Future<String> uploadImage(File image) async {
    final url = '$baseUrl/images/upload';
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      return 'Image uploaded';
    } else {
      throw Exception('Image upload failed');
    }
  }

  // Get file name from url
  String getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments.last;
  }

  // Delete single image
  Future<String> deleteImage(String fullUrl) async {
    final name = getFileNameFromUrl(fullUrl);
    final url = '$baseUrl/images/$name';
    final response = await httpClient.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      return 'Deleted image';
    } else {
      throw Exception('Failed to delete image');
    }
  }

  // Delete multiple images
  Future<String> deleteImages(List<String> fullUrl) async {
    final names = fullUrl.map((e) => getFileNameFromUrl(e)).join(',');
    final url = '$baseUrl/images/delete-multiple?imageNames=$names';
    final response = await httpClient.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      return 'Deleted images';
    } else {
      throw Exception('Failed to delete images');
    }
  }
}
