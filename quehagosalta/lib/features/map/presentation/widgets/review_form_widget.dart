import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/map/data/providers/review_provider.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ReviewFormWidget extends StatefulWidget {
  final String bussinesId;

  const ReviewFormWidget({super.key, required this.bussinesId});

  @override
  State<ReviewFormWidget> createState() => _ReviewFormWidgetState();


}

class _ReviewFormWidgetState extends State<ReviewFormWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
  Future<void> _pickImage() async{
    final XFile? image = await _picker.pickImage(source: 
    ImageSource.gallery, 
    imageQuality: 60
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitReview() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una calificación')),
      );
      return;
    }
    final authProvider = context.read<AuthProvider>();
    final authToken = authProvider.token;
    if (authToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para dejar una reseña')),
      );
      return;
    }
    setState(() => _isSubmitting = true);

    final reviewProvider = context.read<ReviewProvider>();
    final success = await reviewProvider.postReview(
      bussinesId: widget.bussinesId,
      rate: _selectedRating,
      description: _descriptionController.text.trim(),
      authToken: authToken,
      imageUrl: _selectedImage?.path,
    );
    setState(() => _isSubmitting = false);
    if (success) {
      _descriptionController.clear();
      
      setState(() {
        _selectedRating = 0;
        _selectedImage = null;

      } );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gracias por tu opinión!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reviewProvider.errorMessage.isNotEmpty 
            ? reviewProvider.errorMessage 
            : 'Error al publicar. ¿Ya dejaste una reseña aquí?')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Deja tu reseña',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  onPressed: () => setState(() => _selectedRating = starIndex),
                  icon: Icon(
                    starIndex <= _selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            TextField(
              controller: _descriptionController,
              maxLength: 70,
              decoration: const InputDecoration(
                labelText: 'Escribe tu opinión',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 10),
            // --- SELECTOR DE IMAGEN ---
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Adjuntar foto'),
                ),
                const SizedBox(width: 10),
                if (_selectedImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_selectedImage!, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _selectedImage = null),
                        child: const CircleAvatar(
                          radius: 10, 
                          backgroundColor: Colors.red, 
                          child: Icon(Icons.close, size: 12, color: Colors.white)
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 15),
            

            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isSubmitting 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Publicar Reseña', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ]
        )
      )
    );
  }
}