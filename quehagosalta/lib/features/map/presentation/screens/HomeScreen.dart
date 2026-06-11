import 'package:flutter/material.dart';
import 'package:quehagosalta/features/map/presentation/widgets/MapaBaseWidget.dart';
import 'package:quehagosalta/features/map/presentation/widgets/top_bar_widget.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapBaseWidget(),
          // 2. Lo flotante: Tu barra de categorías (Ángel)
          Positioned(
            top:
                50, // Lo baja 50 píxeles para que no lo tape la barra de batería
            left: 0,
            right: 0,
            child: const TopBarWidget(),
          ),
        ],
      ),
    );
  }
}
