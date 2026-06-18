import 'package:flutter/material.dart';
import 'package:quehagosalta/config/routes/app_routes.dart';
import 'package:quehagosalta/features/map/presentation/widgets/MapaBaseWidget.dart';
import 'package:quehagosalta/features/map/presentation/widgets/top_bar_widget.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_button.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapBaseWidget(),
          Positioned(
            top: 730,
            left: 20,
            child: CustomButton(
              text: 'Resgistro 2',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.ownerOnboarding),
            ),
          ),

          Positioned(
            top:
                0, // Lo baja 50 píxeles para que no lo tape la barra de batería
            left: 0,
            right: 0,
            child: const TopBarWidget(),
          ),
        ],
      ),
    );
  }
}
