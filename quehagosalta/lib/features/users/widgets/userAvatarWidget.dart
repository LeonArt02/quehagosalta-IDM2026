import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/config/routes/app_routes.dart';
import 'package:quehagosalta/core/api/api_config.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';

class UserAvatarButton extends StatelessWidget {
  const UserAvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos los datos del usuario logueado de forma reactiva
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    // Si no hay usuario (invitado), mostramos un ícono de cuenta genérico
    if (user == null) {
      return IconButton(
        icon: const Icon(Icons.account_circle, size: 32, color: Colors.grey),
        onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
      );
    }

    // Determinamos el tipo de imagen que tiene cargada el perfil
    ImageProvider? avatarImage;

    // Supongamos que tu UserModel guarda la URL o Path en 'user.profilePicture'
    if (user.profileImage != null && user.profileImage!.isNotEmpty) {
      if (user.profileImage!.startsWith('http')) {
        // Si viene del backend (Django/Supabase URL)
        avatarImage = NetworkImage(user.profileImage!);
      } else {
        // Por si está local en caché recién subida
        avatarImage = FileImage(File(user.profileImage!));
      }
    }

    String? fullAvatarUrl;
    if (user?.profileImage != null && user!.profileImage!.isNotEmpty) {
      final imagePath = user.profileImage!;

      // Nos aseguramos de concatenar correctamente el '/'
      fullAvatarUrl = imagePath.startsWith('/')
          ? "http://${ApiConfig.ipConfigurable}$imagePath"
          : "http://${ApiConfig.ipConfigurable}/$imagePath";
    }

    return GestureDetector(
      onTap: () {
        // Al tocar su foto, lo mandamos a su perfil o panel
        Navigator.pushNamed(context, AppRoutes.profile);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: CircleAvatar(
          radius: 30, // Tamaño ideal para barras superiores (TopBar)
          backgroundColor: Colors.orange.shade200,
          backgroundImage: avatarImage != null
              ? NetworkImage(fullAvatarUrl!)
              : null,
          child: avatarImage == null
              ? Text(
                  // Fallback: Si no tiene foto, mostramos las iniciales de su nombre
                  user.first_name.isNotEmpty
                      ? user.first_name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
