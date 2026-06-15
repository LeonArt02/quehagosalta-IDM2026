import 'dart:io';
import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/core/api/api_config.dart';

class UserService {
  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String token,
    required String firstName,
    required String lastName,
    required String phone,
    File? image,
  }) async {
    final apiClient = ApiClient(baseUrl: ApiConfig.host, token: token);

    return await apiClient.multipartPut(
      endpoint: '/auth/upload/$userId/',

      fields: {'firstName': firstName, 'lastName': lastName, 'phone': phone},

      imagePath: image?.path,
    );
  }
}
