import 'category_model.dart';

class BussinesModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final bool isVerified; // True: Autorizado por autoridades, False: Pendiente
  final double lat;
  final double lng;
  final CategoryModel category;
  final List<String> imageUrls;
  final bool isActive;
  final String owner;

  BussinesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.isVerified,
    required this.lat,
    required this.lng,
    required this.owner,
    required this.isActive,
    required this.category,
    required this.imageUrls,
  });

  factory BussinesModel.fromJson(Map<String, dynamic> json) {
    return BussinesModel(
      id: json['id'] ??'',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      isVerified: json['is_verificated'] ?? json['is_verified'] ?? false,
      isActive: json['is_active'] ?? false,
      lat: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : -24.782126,
      lng: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : -65.423198,
      owner: json['owner'] ?? '',
      // Si la categoría viene nula porque el borrador no la tiene, se evita errores con una cat. vacia.
      category: CategoryModel.fromJson(json['category'] ?? {}),
      imageUrls:
          (json['images'] as List<dynamic>?)
              ?.map((img) => img['image_url'] as String)
              .toList() ??
          [],
    );
  }
}
