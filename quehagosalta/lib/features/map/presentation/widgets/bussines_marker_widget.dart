import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:quehagosalta/features/map/data/models/bussines_model.dart';
import 'package:quehagosalta/core/utils/icon_mapper.dart';

class BusinessMarkerWidget extends StatelessWidget {
  final BussinesModel business;

  const BusinessMarkerWidget({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors
            .red, // 🔴 Base del pin (configurable si agregás color en el back)
        // ⚪ Borde blanco exterior idéntico a tu diseño de referencia
        border: Border.all(color: Colors.white, width: 3.0),
        // 👥 La sombra envolvente que le da el efecto flotante
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // 🎯 Centro del círculo donde renderizamos el icono dinámico extraído con tu utilidad
      child: Center(
        child: Icon(
          business.category.icon_key.toIcon(),
          color: Colors.white,
          size: 22, // Tamaño controlado para que no rompa la estética circular
        ),
      ),
    );
  }
}
