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

  Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(uri, headers: _headers);

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
