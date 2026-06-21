import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/config/routes/app_routes.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';
import 'package:quehagosalta/features/map/data/providers/business_provider.dart';
import 'package:quehagosalta/features/map/presentation/widgets/MapaBaseWidget.dart';
import 'package:quehagosalta/features/map/presentation/widgets/top_bar_widget.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_button.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    //proviiders principales
    final authProvider = context.watch<AuthProvider>();
    final businessProvider = context.watch<BusinessProvider>();

    final user = authProvider.currentUser;
    final token = authProvider.token;
    //verificamos tipo de usuario
    final isBusinessUser =
        user?.roles.any((r) => r.name == 'business_user') ?? false;

    bool hasCompletedRegistration = false;
    if (isBusinessUser && user != null) {
      hasCompletedRegistration = businessProvider.businessesWithoutFilter.any(
        (b) => b.owner == user.id && b.isActive == true,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const MapBaseWidget(),
          Positioned(
            top: 0,
            left: 0,
            right:
                0, // Lo baja 50 píxeles para que no lo tape la barra de batería
            child: const TopBarWidget(),
          ),
          if (isBusinessUser) ...[
            if (!hasCompletedRegistration)
              Positioned(
                bottom: 20,
                left: 10,
                child: FloatingActionButton.extended(
                  heroTag: 'fab_completar_registro',
                  onPressed: () {
                    final bool hasOwnerData =
                        user?.cuil != null &&
                        user!.cuil!.isNotEmpty &&
                        user.profileImage != null &&
                        user.profileImage!.isNotEmpty;
                    if (hasOwnerData) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.businessRegister,
                        arguments: {
                          'cuil': user.cuil,
                          'profileImage': null,
                          'isFromProfile': true,
                        },
                      );
                    } else {
                      Navigator.pushNamed(context, AppRoutes.ownerOnboarding);
                    }
                  },

                  backgroundColor: Colors.orange,
                  elevation: 6,
                  icon: const Icon(Icons.assignment_late, color: Colors.white),
                  label: const Text(
                    'Completar Registro del Negocio',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              Positioned(
                bottom: 90,
                right: 20,
                child: FloatingActionButton(
                  heroTag: 'fab_gestion_negocio',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.homeScreen);
                  },
                  backgroundColor: Colors.green,
                  elevation: 2,
                  child: const Icon(Icons.storefront, color: Colors.white),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
