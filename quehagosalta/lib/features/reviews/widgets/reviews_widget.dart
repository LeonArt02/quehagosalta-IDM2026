import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/reviews/data/providers/review_provider.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';
import 'package:quehagosalta/features/reviews/widgets/reviews_section_widget.dart';
import 'package:quehagosalta/features/reviews/widgets/review_form_widget.dart';

// clase que junta review_form_widget y reviews_section_widget, para mostrar reseñas y el formulario en la misma pantalla
class ReviewsWidget extends StatefulWidget {
  final String bussinesId;
  const ReviewsWidget({super.key, required this.bussinesId});
  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().loadReviewsForBusiness(widget.bussinesId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Revisamos si el usuario está logueado para mostrar o no el formulario
    final authProvider = context.watch<AuthProvider>();
    final bool isUserLoggedIn =
        authProvider.token != null && authProvider.token!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1, height: 40),

        const Text(
          'Opiniones',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // 1. Mostrar formulario SOLO si está logueado
        if (isUserLoggedIn)
          ReviewFormWidget(bussinesId: widget.bussinesId)
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Inicia sesión para dejar una reseña.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),

        const SizedBox(height: 24),

        // 2. Lista de reseñas (hasta 15)
        const ReviewsSectionWidget(),

        // Un poco de espacio extra al fondo para que el último elemento no quede pegado al borde del teléfono
        const SizedBox(height: 40),
      ],
    );
  }
}
