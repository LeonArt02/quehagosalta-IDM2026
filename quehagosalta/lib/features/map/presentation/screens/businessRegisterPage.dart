import 'package:flutter/material.dart';
// Importa tu BusinessProvider aquí (asumiendo que le agregaremos el método de crear)
// import 'package:quehagosalta/features/map/data/providers/business_provider.dart';
import 'package:quehagosalta/core/validators/validator.dart';
import 'package:quehagosalta/features/map/data/services/toast_service.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_button.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/map/data/providers/business_provider.dart';
import 'package:quehagosalta/features/map/data/providers/locationProvider.dart';
import 'package:latlong2/latlong.dart'; 
class BusinessRegisterPage extends StatefulWidget {
  const BusinessRegisterPage({super.key});

  @override
  State<BusinessRegisterPage> createState() => _BusinessRegisterPageState();
}

class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controladores basados en tu BusinessModel
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();


  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _registerBusiness() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Aquí llamarías a tu BusinessProvider para enviar los datos a Django
    // final businessProvider = context.read<BusinessProvider>();
        final locationProvider = context.read<LocationProvider>();
    final _currentLocation = locationProvider.currentPosition ?? LatLng(-24.782126, -65.423198); // Salta centro como fallback  

    final businessProvider = context.read<BusinessProvider>();
    try {
       await businessProvider.createBusiness(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        location: _currentLocation,
      );

      if (!mounted) return;

      ToastService.success('¡Local registrado con éxito! Pendiente de validación.');

      // Redirigimos al Dashboard del negocio o al mapa
      Navigator.pushReplacementNamed(context, '/home'); // /business_dashboard sería la ruta del dashboard del negocio
      
    } catch (e) {
      ToastService.error(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.storefront, size: 70, color: Colors.orange),
                    const SizedBox(height: 10),
                    const Text(
                      'REGISTRAR LOCAL',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ingresa los datos de tu comercio gastronómico en Salta',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    // ==========================================
                    // CAMPOS DEL LOCAL
                    // ==========================================
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre del Local',
                      icon: Icons.restaurant,
 // Asumiendo que tienes este validador
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _addressController,
                      label: 'Dirección (Ej: Balcarce 123)',
                      icon: Icons.location_on,

                    ),
                    const SizedBox(height: 20),

                    // Usamos un campo para la descripción, sería ideal que CustomTextField
                    // soporte el parámetro "maxLines" para que sea una caja grande.
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Descripción (Especialidad, ambiente, etc.)',
                      icon: Icons.description,

                    ),
                    const SizedBox(height: 30),

                    // ==========================================
                    // BOTÓN DE REGISTRO
                    // ==========================================
                    CustomButton(
                      text: 'ENVIAR SOLICITUD',
                      loading: _isLoading,
                      onPressed: _registerBusiness,
                    ),
                    const SizedBox(height: 10),

                    // Botón para omitir y configurar después
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/business_dashboard');
                      },
                      child: const Text(
                        'Configurar más tarde',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}