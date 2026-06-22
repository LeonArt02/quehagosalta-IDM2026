import 'package:flutter/material.dart';

import '../../../map/data/models/role_model.dart';

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
    final Map<String, dynamic> targetJson = json.containsKey('data')
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawId = targetJson['id'];
    final String safeId = (rawId != null && rawId.toString() != 'null')
        ? rawId.toString()
        : '';

    final String rawImage =
        (targetJson['image'] ??
                targetJson['profile_image'] ??
                targetJson['profileImage'] ??
                '')
            .toString();
    String safeProfileImage = rawImage;
    if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
      const String baseUrl = 'http://192.168.100.15';
      safeProfileImage =
          rawImage.startsWith('/') //que no se dupliquen '/'
          ? '$baseUrl$rawImage'
          : '$baseUrl/$rawImage';
    }

    return UserModel(
      id: safeId,
      first_name: targetJson['first_name'] ?? '',
      last_name: targetJson['last_name'] ?? '',
      email: targetJson['email'] ?? targetJson['username'] ?? '',
      phone: targetJson['phone']?.toString(),
      cuil: (targetJson['cuil'] ?? targetJson['CUIL'] ?? '').toString(),
      profileImage: safeProfileImage,
      roles: targetJson['roles'] != null
          ? List<RoleModel>.from(
              (targetJson['roles'] as List).map(
                (roleJson) => RoleModel.fromJson(roleJson),
              ),
            )
          : [],
    );
  }
}
