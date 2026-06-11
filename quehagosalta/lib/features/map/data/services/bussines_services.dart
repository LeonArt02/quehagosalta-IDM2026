import 'package:quehagosalta/core/api/api_client.dart';

class BussinesServices {
  final ApiClient _apiClient;

  BussinesServices(this._apiClient);

  Future<Map<String, dynamic>> getBussines() async {
    return await _apiClient.get('/bussines/');
  }
}
