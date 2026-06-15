import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  String? token;

  ApiClient({required this.baseUrl, this.token});

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};

    if (token != null) {
      headers['Autorization'] = token!;
    }

    return headers;
  }

  // agrego post
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(uri, headers: _headers);

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> multipartPut({
    required String endpoint,
    required Map<String, String> fields,
    String? imagePath,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({'Authorization': token ?? ''});

    request.fields.addAll(fields);

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    // Logs automáticos en consola para que veas qué pasa en vivo
    debugPrint('⚡ [ApiClient] URL: ${response.request?.url}');
    debugPrint('📊 [ApiClient] STATUS: ${response.statusCode}');
    debugPrint('📦 [ApiClient] BODY: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': data};
    }

    return {
      'success': false,
      'message': data['message'] ?? 'Error desconocido en el servidor',
    };
  }
}
