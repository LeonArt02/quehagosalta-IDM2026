import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class MapsNavigationServices {
  /// Abre la aplicación de Google Maps con una ruta trazada desde el origen al destino.
  static Future<void> getDirections({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    BuildContext?
    context, // Opcional, para mostrar un SnackBar en caso de error
  }) async {
    // URL de Google Maps
    final String urlString =
        'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destLat,$destLng';

    final Uri googleMapsUrl = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        // LaunchMode.externalApplication fuerza la apertura en la app nativa de Maps si está instalada
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se pudo inicializar la navegación.');
      }
    } catch (e) {
      debugPrint('Error al abrir Google Maps: $e');
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo abrir Google Maps. Verifica tu conexión o instalación.',
            ),
          ),
        );
      }
    }
  }
}
