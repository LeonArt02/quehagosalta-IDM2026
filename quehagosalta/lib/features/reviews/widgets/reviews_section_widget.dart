import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/reviews/data/providers/review_provider.dart';
import 'package:quehagosalta/core/api/api_config.dart';
import 'package:quehagosalta/features/map/presentation/widgets/fullscreen_image_viewer.dart';

class ReviewsSectionWidget extends StatelessWidget {
  const ReviewsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final review_provider = Provider.of<ReviewProvider>(context);
    if (review_provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      );
    }

    if (review_provider.reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No hay reseñas para este negocio.'),
      );
    }
    // mostrar solo las 10 primeras reseñas para evitar saturar la UI
    final displayReviews = review_provider.reviews.length > 10
        ? review_provider.reviews.sublist(0, 10)
        : review_provider.reviews;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayReviews.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final review = displayReviews[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(
              review.username[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(review.username),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rate ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(review.description),
              const SizedBox(height: 4),
              // --- VISUALIZADOR DE IMAGEN ---
              if (review.imageUrl != null && review.imageUrl!.isNotEmpty) ...[
                (() {
                  String path = review.imageUrl!;
                  String fullUrl = "";

                  // 🌟 LÓGICA INFALIBLE 🌟
                  // Si Django ya hizo el trabajo sucio y nos mandó la URL completa:
                  if (path.startsWith('http')) {
                    fullUrl = path;
                  }
                  // Si Django solo nos mandó el pedacito de ruta (caso de negocios):
                  else {
                    if (!path.startsWith('/uploads/')) {
                      path = path.startsWith('/')
                          ? '/uploads$path'
                          : '/uploads/$path';
                    }
                    fullUrl = "http://${ApiConfig.ipConfigurable}:8000$path";
                  }

                  final heroTag = 'review-image-${review.id}';

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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Hero(
                        tag: heroTag,
                        child: Image.network(
                          fullUrl, // <-- Usamos la variable ya procesada
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint("Error al cargar: $fullUrl");
                            return const SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  'No se pudo cargar la imagen',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }()),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 4),
              Text(
                'Hace ${DateTime.now().difference(review.createdAt).inDays} días',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
