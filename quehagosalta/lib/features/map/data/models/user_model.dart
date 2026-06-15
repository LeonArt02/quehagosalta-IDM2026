import 'role_model.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? image;
  final List<RoleModel> roles;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.image,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      firstName: json['name'] ?? '',
      lastName: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString(),
      image: json['image'],
      roles: json['roles'] != null
          ? List<RoleModel>.from(
              (json['roles'] as List).map(
                (roleJson) => RoleModel.fromJson(roleJson),
              ),
            )
          : [],
    );
  }
}
