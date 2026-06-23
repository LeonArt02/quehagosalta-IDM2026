import 'package:quehagosalta/features/reviews/data/models/review_model.dart';
import 'package:quehagosalta/core/api/api_config.dart';
import 'package:flutter/material.dart';
import 'package:quehagosalta/core/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:quehagosalta/features/reviews/data/services/review_services.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewServices _service;

  // Inyección de dependencias a través del constructor
  ReviewProvider(this._service);

  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Carga las reseñas y filtra en memoria las que corresponden a [bussinesId]
  Future<void> loadReviewsForBusiness(String bussinesId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final dynamic response = await _service.getReviews();

      // Manejamos si el backend devuelve un paginador (results) o la data directa
      List<dynamic> rawList = [];
      if (response is List) {
        rawList = response;
      } else if (response is Map) {
        rawList = response['results'] ?? response['data'] ?? [];
      }

      _reviews = rawList
          .map((json) => ReviewModel.fromJson(json))
          // Aquí filtramos para mostrar solo las del negocio seleccionado
          .where((review) => review.bussinesId == bussinesId)
          .toList();

      // Ordenamo
      _reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _errorMessage = 'Error al cargar las reseñas: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Envía una reseña y recarga la lista si todo sale bien
  Future<bool> postReview({
    required String bussinesId,
    required int rate,
    required String description,
    required String authToken,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _service.postReview(
        bussinesId: bussinesId,
        rate: rate,
        description: description,
        token: authToken,
        imageUrl: imageUrl,
      );

      // Si fue exitoso, recargamos la lista
      await loadReviewsForBusiness(bussinesId);
      return true;
    } catch (e) {
      // Aquí saltará si el servidor devuelve Error 400 (Reseña duplicada)
      _errorMessage = 'Error al publicar la reseña: $e';
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
