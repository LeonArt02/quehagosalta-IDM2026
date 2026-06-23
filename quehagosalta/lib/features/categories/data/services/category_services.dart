import 'package:quehagosalta/core/api/api_client.dart';

class CategoryServices {
  final ApiClient _apiClient;

  CategoryServices(this._apiClient);

  Future<Map<String, dynamic>> getCategories() async {
    return await _apiClient.get('/categories/');
  }
}
