import 'role_model.dart';
class UserModel {

  final int id;
  final String name;
  final String lastname;
  final String email;
  final String? phone;
  final String? image;
  final List<RoleModel> roles;

  UserModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    this.phone,
    this.image,
    required this.roles,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      roles: json['roles'] != null 
          ? List<RoleModel>.from(
              (json['roles'] as List).map((roleJson) => RoleModel.fromJson(roleJson))
            )
          : [],

      
    );
  }
}

