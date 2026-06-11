import 'package:flutter/material.dart';
import 'package:quehagosalta/features/map/data/models/bussines_model.dart';
import 'package:quehagosalta/features/map/data/services/maps_navigation_services.dart';

class BussinesDetailSheet extends StatelessWidget {
  final BussinesModel bussines;
  final double userLat; // Ubicación actual 
  final double userLng;

  const BussinesDetailSheet({
    Key? key,
    required this.bussines,
    required this.userLat,
    required this.userLng,
  }) : super(key: key);

  /// Método estático para invocar el BottomSheet desde el mapa fácilmente
  static void show(BuildContext context, BussinesModel bussines, double userLat, double userLng) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BussinesDetailSheet(
        bussines: bussines,
        userLat: userLat,
        userLng: userLng,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4, // Ocupa el 40% de la pantalla al abrir
      minChildSize: 0.3,     // Mínimo al que se puede reducir antes de cerrarse
      maxChildSize: 0.85,    // Máximo al expandirse
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: controller,
            children: [
              // Barra indicadora de arrastre
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Encabezado: Nombre y Badge de Verificación
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      bussines.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildVerificationBadge(),
                ],
              ),
              const SizedBox(height: 15),



              // Descripción
              Text(
                bussines.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 30),

              // Botón de Acción: "Cómo llegar" con maps :D
              ElevatedButton.icon(
                onPressed: () {
                  MapsNavigationServices.getDirections(
                    originLat: userLat,
                    originLng: userLng,
                    destLat: bussines.lat,
                    destLng: bussines.lng,
                    context: context,
                  );
                },
                icon: const Icon(Icons.directions),
                label: const Text('Cómo llegar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.redAccent, // Ajusta a tu paleta (ej. colores regionales de Salta)
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget helper para el estado de verificación
  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bussines.isVerified ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: bussines.isVerified ? Colors.green : Colors.orange,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            bussines.isVerified ? Icons.verified : Icons.pending_actions,
            size: 16,
            color: bussines.isVerified ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            bussines.isVerified ? 'Oficial' : 'Pendiente',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: bussines.isVerified ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}