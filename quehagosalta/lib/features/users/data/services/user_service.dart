import 'dart:io';
import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/core/api/api_config.dart';

class UserService {
  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String token,
    required String first_name,
    required String last_name,
    required String phone,
    File? image,
  }) async {
    final apiClient = ApiClient(baseUrl: ApiConfig.host, token: token);

    return await apiClient.multipartPut(
      endpoint: '/auth/upload/$userId/',

      fields: {
        'first_name': first_name,
        'last_name': last_name,
        'phone': phone,
      },

      imagePath: image?.path,
    );
  }
}
