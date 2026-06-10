class CategoryModel {
  final String id;
  final String name;
  final String icon_key;

  CategoryModel({required this.id, required this.name, required this.icon_key});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon_key:
          json['icon_key'], // Ojo acá: mapeá el 'icon_key' de Python a tu variable
    );
  }
}
