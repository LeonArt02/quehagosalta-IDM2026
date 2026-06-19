import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/config/routes/app_routes.dart';
import 'package:quehagosalta/core/validators/validator.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';
import 'package:quehagosalta/features/auth/data/services/toast_service.dart';
import 'package:quehagosalta/features/map/presentation/widgets/CustomFlutterMap.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_button.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_textfield.dart';
import 'package:quehagosalta/features/map/data/providers/business_provider.dart';
import 'package:quehagosalta/features/map/data/providers/locationProvider.dart';
import 'package:quehagosalta/features/map/data/providers/category_provider.dart';

class BusinessRegisterPage extends StatefulWidget {
  const BusinessRegisterPage({super.key});

  @override
  State<BusinessRegisterPage> createState() => _BusinessRegisterPageState();
}

class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedCategoryId;
  LatLng _selectedCoordinates = const LatLng(
    -24.782126,
    -65.423198,
  ); // Salta centro fallback
  bool _isMapInitialized = false;
  bool _isLoading = false;

  // Manejo de la galería de imágenes del local (Máximo 5)
  final List<File> _businessImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  void initState() {
    super.initState();
    _mapController.mapEventStream.listen((event) {
      _selectedCoordinates = event.camera.center;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _pickBusinessImage() async {
    if (_businessImages.length >= 5) {
      ToastService.error('Ya has alcanzado el límite máximo de 5 fotos.');
      return;
    }
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() => _businessImages.add(File(pickedFile.path)));
    }
  }

  Future<void> _registerBusiness(String cuil, File profileImage) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      ToastService.error(
        'Por favor, selecciona una categoría para tu negocio.',
      );
      return;
    }

    if (_businessImages.isEmpty) {
      ToastService.error('Por favor, agrega al menos una imagen de tu local.');
      return;
    }

    setState(() => _isLoading = true);

    final businessProvider = context.read<BusinessProvider>();

    // 1. Extraemos el AuthProvider para sacar el token de sesión real que Django nos dio al loguearnos/registrarnos
    final authProvider = context.read<AuthProvider>();
    final String secureToken =
        authProvider.token ??
        ''; // Si por alguna razón es nulo, mandamos cadena vacía

    try {
      await businessProvider.completeBusinessProfile(
        cuil: cuil,
        imagePath: profileImage.path,
        businessImagesPaths: _businessImages
            .map((file) => file.path)
            .toList(), // Lista de paths (Strings) de la galería del local
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        address: _addressController.text.trim(),
        categoryId: _selectedCategoryId!,
        latitude: _selectedCoordinates.latitude,
        longitude: _selectedCoordinates.longitude,
        authToken: secureToken,
      );

      if (!mounted) return;

      ToastService.success(
        '¡Local registrado con éxito! Pendiente de validación.',
      );
      Navigator.pushReplacementNamed(context, '/home');
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
    // 1. Recorremos los datos heredados del Paso 1 (OwnerOnboardingPage)
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic> ??
        {};
    final String cuil = args['cuil'];
    final File profileImage = args['profileImage'];

    // 2. Inicializamos el mapa con el GPS del dispositivo
    if (!_isMapInitialized) {
      final locationProvider = context.read<LocationProvider>();
      if (locationProvider.currentPosition != null) {
        _selectedCoordinates = locationProvider.currentPosition!;
      }
      _isMapInitialized = true;
    }

    // 3. Consumimos las categorías reales de tu CategoryProvider
    final categoryProvider = context.watch<CategoryProvider>();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.storefront,
                            size: 70,
                            color: Colors.orange,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'REGISTRAR LOCAL',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Ingresa los datos de tu comercio gastronómico en Salta',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre del Local',
                      icon: Icons.restaurant,
                    ),
                    const SizedBox(height: 20),

                    // Selector Dropdown dinámico conectado a tu CategoryProvider real
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Categoría del Comercio *',
                        prefixIcon: Icon(Icons.category, color: Colors.orange),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCategoryId,
                      items: categoryProvider.categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat
                              .id, // Suponiendo que tu CategoryModel tiene .id (UUID)
                          child: Text(cat.name), // Suponiendo que tiene .name
                        );
                      }).toList(),
                      onChanged: (val) => {
                        setState(() => _selectedCategoryId = val),
                      },
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _addressController,
                      label: 'Dirección (Ej: Balcarce 123)',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Descripción (Especialidad, ambiente, etc.)',
                      icon: Icons.description,
                    ),
                    const SizedBox(height: 25),

                    // IMÁGENES (MÁXIMO 5)
                    const Text(
                      'Fotos de tu Local (Máximo 5) *',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 85,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _businessImages.length < 5
                            ? _businessImages.length + 1
                            : 5,
                        itemBuilder: (context, index) {
                          if (index == _businessImages.length &&
                              _businessImages.length < 5) {
                            return GestureDetector(
                              onTap: _pickBusinessImage,
                              child: Container(
                                width: 85,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.orange,
                                  size: 28,
                                ),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              Container(
                                width: 85,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(_businessImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () => setState(
                                    () => _businessImages.removeAt(index),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 9,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 25),

                    // MAPA BASE
                    const Text(
                      'Ubica tu local en el mapa (Mueve el mapa bajo el pin) *',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Stack(
                          children: [
                            // Invocamos a tu mapa base personalizado
                            Customfluttermap(
                              mapController: _mapController,
                              centerPosition: _selectedCoordinates,
                              markers:
                                  const [], // Pasamos lista vacía para usar el truco del Pin estático flotando
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(35),
                                child: Icon(
                                  Icons.location_pin,
                                  size: 45,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    CustomButton(
                      text: 'ENVIAR SOLICITUD',
                      loading: _isLoading,
                      onPressed: () => _registerBusiness(cuil, profileImage),
                    ),
                    const SizedBox(height: 10),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.homeScreen,
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text(
                          'Configurar más tarde',
                          style: TextStyle(color: Colors.grey),
                        ),
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
