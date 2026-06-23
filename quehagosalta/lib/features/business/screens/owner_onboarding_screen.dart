import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:quehagosalta/config/routes/app_routes.dart';
import 'package:quehagosalta/core/validators/validator.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_button.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_textfield.dart';
import 'package:quehagosalta/features/auth/data/services/toast_service.dart';

class OwnerOnboardingPage extends StatefulWidget {
  const OwnerOnboardingPage({super.key});

  @override
  State<OwnerOnboardingPage> createState() => _OwnerOnboardingPageState();
}

class _OwnerOnboardingPageState extends State<OwnerOnboardingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _cuilController = TextEditingController();
  File? _profileImage;
  final _picker = ImagePicker();

  // Máscara argentina para cuil: XX-XXXXXXXX-X
  final _cuilFormatter = MaskTextInputFormatter(
    mask: '##-########-#',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    _cuilController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );
      if (pickedFile != null) {
        setState(() => _profileImage = File(pickedFile.path));
      }
    } catch (e) {
      ToastService.error('Error al seleccionar la imagen: $e');
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar foto con la Cámara'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de la Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _continueToBusinessForm() {
    if (_profileImage == null) {
      ToastService.error(
        'La foto de perfil es obligatoria para tu cuenta comercial.',
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    // Navegamos al paso 2 enviando los datos recolectados en los argumentos de la ruta
    Navigator.pushNamed(
      context,
      AppRoutes.businessRegister,
      arguments: {
        'cuil': _cuilController.toString(),
        'profileImage': _profileImage,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paso 1: Datos del Dueño')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.black54,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Foto de Perfil Comercial *',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _cuilController,
                keyboardType: TextInputType.number,
                inputFormatters: [_cuilFormatter],
                validator: Validators.cuil,
                decoration: const InputDecoration(
                  labelText: 'Tu cuil/CUIT *',
                  hintText: '20-12345678-9',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'CONTINUAR AL NEGOCIO',
                loading: false,
                onPressed: _continueToBusinessForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
