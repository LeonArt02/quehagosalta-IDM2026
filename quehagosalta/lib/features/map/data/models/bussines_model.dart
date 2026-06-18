import 'category_model.dart';

class BussinesModel {
  final String name;
  final String description;
  final String address;
  final bool isVerified; // True: Autorizado por autoridades, False: Pendiente
  final double lat;
  final double lng;
  final CategoryModel category;
  final List<String> imageUrls;

  BussinesModel({
    required this.name,
    required this.description,
    required this.address,
    required this.isVerified,
    required this.lat,
    required this.lng,
    required this.category,
    required this.imageUrls,
  });

  factory BussinesModel.fromJson(Map<String, dynamic> json) {
    return BussinesModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      isVerified: json['is_verificated'] ?? json['is_verified'] ?? false,

      lat: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : -24.782126,
      lng: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : -65.423198,

      // Si la categoría viene nula porque el borrador no la tiene, evita romper instanciando un modelo vacío
      category: CategoryModel.fromJson(json['category'] ?? {}),
      imageUrls:
          (json['images'] as List<dynamic>?)
              ?.map((img) => img['image_url'] as String)
              .toList() ??
          [],
    );
  }
}
