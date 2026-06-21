import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/map/data/providers/review_provider.dart';
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
  
    if(review_provider.reviews.isEmpty){
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No hay reseñas para este negocio.'),
      );
    }
    // mostrar solo las 10 primeras reseñas para evitar saturar la UI
    final displayReviews =review_provider.reviews.length > 10
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
          child: Text(review.username[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
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