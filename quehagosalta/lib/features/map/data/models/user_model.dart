import 'package:flutter/material.dart';

import 'role_model.dart';

class UserModel {
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? cuil;
  final List<RoleModel> roles;

  UserModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    this.phone,
    this.profileImage,
    this.cuil,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    debugPrint("=== JSON CRUDO DESDE DJANGO EN USERMODEL ===");
    debugPrint(json.toString());
    debugPrint("=============================================");

    return UserModel(
      id: json['id'].toString(),
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      email: json['email'] ?? json['username'] ?? '',
      phone: json['phone']?.toString(),
      cuil: (json['cuil'] != null && json['cuil'].toString() != 'null')
          ? json['cuil'].toString()
          : '',
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
