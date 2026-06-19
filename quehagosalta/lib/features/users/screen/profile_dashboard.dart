import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';

class Profile_dashboard extends StatelessWidget {
  const Profile_dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    final isBussines =
        user?.roles.any((rol) => rol.name == 'business_user') ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(isBussines ? 'Panel de control Comercial' : 'Mi Perfil'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.profileImage != null
                  ? NetworkImage(user!.profileImage!)
                  : null,
              child: user?.profileImage == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              'Hola, ${user?.firstName ?? "Usuario"}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            if (!isBussines) ...[
              const Card(
                //Reseñas
              ),
            ] else ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.badge, color: Colors.orange),
                  title: const Text('Datos Fiscales (CUIL/CUIT)'),
                  subtitle: Text(user?.cuil ?? 'No'),
                ),
              ),
            ],

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                authProvider.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('CERRAR SESIÓN'),
            ),
          ],
        ),
      ),
    );
  }
}
