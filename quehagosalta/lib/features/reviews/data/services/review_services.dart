import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/features/reviews/data/models/review_model.dart';
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
    String? imageUrl,
  }) async {
    _apiClient.token = token.startsWith('Bearer') ? token : 'Bearer $token';

    if (imageUrl == null || imageUrl.isEmpty) {
      return await _apiClient.post('/reviews/', {
        'bussines': bussinesId,
        'rate': rate,
        'description': description,
      });
    }

    return await _apiClient.multipartPost(
      endpoint: '/reviews/',
      imagePath: imageUrl, //
      imageFieldKey: 'photo',
      fields: {
        'bussines': bussinesId,
        'rate': rate.toString(),
        'description': description,
      },
    );
  }
}
