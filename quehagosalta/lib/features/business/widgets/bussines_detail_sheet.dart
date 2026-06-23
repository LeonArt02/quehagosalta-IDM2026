import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:quehagosalta/features/business/data/models/bussines_model.dart';
import 'package:quehagosalta/features/map/data/services/maps_navigation_services.dart';
import 'package:quehagosalta/features/map/presentation/widgets/fullscreen_image_viewer.dart';
import 'package:quehagosalta/core/api/api_config.dart';
import 'package:quehagosalta/features/reviews/widgets/reviews_widget.dart';

class BussinesDetailSheet extends StatelessWidget {
  final BussinesModel bussines;
  final LatLng userLocation;

  const BussinesDetailSheet({
    Key? key,
    required this.bussines,
    required this.userLocation,
  }) : super(key: key);

  /// Método estático para invocar el BottomSheet desde el mapa fácilmente
  static void show(
    BuildContext context,
    BussinesModel bussines,
    LatLng userLocation,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BussinesDetailSheet(bussines: bussines, userLocation: userLocation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

    return DraggableScrollableSheet(
      initialChildSize: 0.5, // Ocupa el 50% de la pantalla al abrir
      minChildSize: 0.3, // Mínimo al que se puede reducir antes de cerrarse
      maxChildSize: 0.95, // Máximo al expandirse
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

              // Fotos
              if (bussines.imageUrls.isNotEmpty) ...[
                const SizedBox(height: 20),
                SizedBox(
                  height:
                      220, // 1. Mantenemos el tamaño del contenedor principal
                  child: SizedBox(
                    height:
                        220, // 2. IMPORTANTE: Envolvemos el Stack para darle límites verticales fijos dentro del ListView
                    child: Stack(
                      children: [
                        // El Carrusel Principal
                        PageView.builder(
                          controller: pageController,
                          itemCount: bussines.imageUrls.length,
                          onPageChanged: (int index) {
                            currentPageNotifier.value = index;
                          },
                          itemBuilder: (context, index) {
                            final imagePath = bussines.imageUrls[index];
                            final fullUrl =
                                "http://${ApiConfig.ipConfigurable}$imagePath";
                            final heroTag = 'bussines-image-$fullUrl';

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FullscreenImageViewer(
                                      imageUrl: fullUrl,
                                      tag: heroTag,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[200],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Hero(
                                    tag: heroTag,
                                    child: Image.network(
                                      fullUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Capa Reactiva de Flechas de Navegación (Solo si hay más de 1 imagen)
                        if (bussines.imageUrls.length > 1)
                          ValueListenableBuilder<int>(
                            valueListenable: currentPageNotifier,
                            builder: (context, pageIndex, child) {
                              final isFirstPage = pageIndex == 0;
                              final isLastPage =
                                  pageIndex == bussines.imageUrls.length - 1;

                              return Stack(
                                children: [
                                  // Flecha Izquierda (Retroceder)
                                  if (!isFirstPage)
                                    Positioned(
                                      left: 10,
                                      top: 0,
                                      bottom: 0,
                                      child: Center(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black45,
                                          radius: 18,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.arrow_back_ios_new,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              pageController.previousPage(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Flecha Derecha (Avanzar)
                                  if (!isLastPage)
                                    Positioned(
                                      right: 10,
                                      top: 0,
                                      bottom: 0,
                                      child: Center(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black45,
                                          radius: 18,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              pageController.nextPage(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

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
                    originLat: userLocation.latitude,
                    originLng: userLocation.longitude,
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
                  backgroundColor: Colors
                      .redAccent, // Ajusta a tu paleta (ej. colores regionales de Salta)
                  foregroundColor: Colors.white,
                ),
              ),
              ReviewsWidget(bussinesId: bussines.id),
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
