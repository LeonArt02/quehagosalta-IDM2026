import 'dart:io';
import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/core/api/api_config.dart';

class UserService {
  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String token,
    required String name,
    required String lastname,
    required String phone,
    File? image,
  }) async {
    final apiClient = ApiClient(baseUrl: ApiConfig.host, token: token);

    return await apiClient.multipartPut(
      endpoint: '/auth/upload/$userId/',

      fields: {'name': name, 'lastname': lastname, 'phone': phone},

      imagePath: image?.path,
    );
  }
}
