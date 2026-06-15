class RoleModel {
  final String id;
  final String name;
  final String image;
  final String route;

  RoleModel({
    required this.id,
    required this.name,
    required this.image,
    required this.route,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      route: json['route']?.toString() ?? '',
    );
  }
}
