import 'package:quehagosalta/core/api/api_client.dart'; 
import 'package:quehagosalta/features/map/data/models/review_model.dart';
import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/core/api/api_config.dart';

class ReviewServices {
  final ApiClient _apiClient;

  ReviewServices(this._apiClient);

  // GET: todas las reseñas
  Future<Map<String, dynamic>> getReviews() async {
    return await _apiClient.get('/reviews/');
  }

  // POST: Publicar una reseña
  Future<Map<String, dynamic>> postReview({
    required String bussinesId,
    required int rate,
    required String description,
    required String token,
  }) async {
    _apiClient.token = token.startsWith('Bearer') ? token : 'Bearer $token';
    // Usamos el método post de tu ApiClient
    return await _apiClient.post(
      '/reviews/',
      {
        'bussines': bussinesId,
        'rate': rate,
        'description': description,
      },
    );
  }
}