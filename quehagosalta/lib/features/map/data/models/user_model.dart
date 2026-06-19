import 'role_model.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? cuil;
  final List<RoleModel> roles;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.profileImage,
    this.cuil,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString(),
      cuil: json['cuil'] ?? '',
      profileImage:
          json['image'] ?? json['profile_image'] ?? json['profileImage'],
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
