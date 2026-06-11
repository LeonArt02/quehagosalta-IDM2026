class BussinesModel {
  final String name;
  final String description;
  final String address;
  final bool isVerified; // True: Autorizado por autoridades, False: Pendiente
  final double lat;
  final double lng;

  BussinesModel({
    required this.name,
    required this.description,
    required this.address,
    required this.isVerified,
    required this.lat,
    required this.lng,
  });

  factory BussinesModel.fromJson(Map<String, dynamic> json) {
    return BussinesModel(
      name: json['name'],
      description: json['description'],
      address: json['address'],
      isVerified: json['is_verified'], // Asegúrate de que el JSON tenga esta clave
      lat: json['lat'],
      lng: json['lng'],
    );
  } 
}