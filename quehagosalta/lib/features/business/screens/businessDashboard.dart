import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:provider/provider.dart';
import 'package:quehagosalta/core/api/api_config.dart';
import 'package:quehagosalta/features/business/data/models/bussines_model.dart';
import 'package:quehagosalta/features/business/data/providers/business_provider.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<String> _currentRemoteImages = []; // URLs remotas visibles
  List<XFile> _selectedNewImagesFiles = []; // Archivos locales para subir
  bool _isImagesInitialized = false;
  bool _isControllersInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final businessProvider = Provider.of<BusinessProvider>(
        context,
        listen: false,
      );

      if (authProvider.token != null) {
        await businessProvider.loadMyBusiness(authProvider.token!);
        final business = businessProvider.myBusiness;
        if (business != null) {
          setState(() {
            _nameController.text = business.name;
            _descriptionController.text = business.description;
          });
          debugPrint(
            "✅ Flujo Completado: Controladores cargados con: ${business.name}",
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessProvider = context.watch<BusinessProvider>();
    final authProvider = context.watch<AuthProvider>();
    final business = businessProvider.myBusiness;

    if (businessProvider.isLoading && business == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    if (business == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Panel de Mi Negocio')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storefront, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  businessProvider.errorMessage.isNotEmpty
                      ? businessProvider.errorMessage
                      : 'Cargando datos de tu comercio...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_isControllersInitialized || _nameController.text != business.name) {
      _nameController.text = business.name;
      _descriptionController.text = business.description;
      _isControllersInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel de Mi Negocio',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: businessProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECCIÓN IMÁGENES (EDITABLE / VISUALIZACIÓN) ---
                    const Text(
                      'Galería de Imágenes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (!_isImagesInitialized) ...[
                      () {
                        _currentRemoteImages = List.from(business.imageUrls);
                        _isImagesInitialized = true;
                        return const SizedBox.shrink();
                      }(),
                    ],

                    (_currentRemoteImages.isEmpty &&
                            _selectedNewImagesFiles.isEmpty)
                        ? Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Sin imágenes registradas'),
                            ),
                          )
                        : SizedBox(
                            height: 120,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ..._currentRemoteImages.map((imagePath) {
                                  final fullUrl =
                                      "http://${ApiConfig.ipConfigurable}$imagePath";
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                          top: 5,
                                        ),
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(fullUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 5,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _currentRemoteImages.remove(
                                                  imagePath,
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),

                                ..._selectedNewImagesFiles.map((file) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                          top: 5,
                                        ),
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.amber,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: Image.network(
                                            file.path,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Image.file(
                                                    io.File(file.path),
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 5,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.black,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _selectedNewImagesFiles.remove(
                                                  file,
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                    const SizedBox(height: 12),

                    // Botón para seleccionar imágenes locales de la galería (Corregido)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final List<XFile>? images = await _picker
                                  .pickMultiImage();
                              if (images != null && images.isNotEmpty) {
                                setState(() {
                                  _selectedNewImagesFiles.addAll(images);
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.photo_library,
                              color: Colors.amber,
                            ),
                            label: const Text(
                              'Agregar Fotos',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- DATOS EDITABLES ---
                    const Text(
                      'Información Editable',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Input Nombre
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del Negocio',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.storefront),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'El nombre es obligatorio' : null,
                    ),
                    const SizedBox(height: 16),

                    // Input Descripción
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Descripción / Qué ofreces',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.description),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Agrega una breve descripción'
                          : null,
                    ),
                    const Divider(height: 32),

                    // --- DATOS DE SOLO LECTURA ---
                    const Text(
                      'Datos Fijos (No Editables)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Categoría fija
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.category, color: Colors.grey),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Categoría asignada',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                business.category.name.isNotEmpty
                                    ? business.category.name
                                    : 'Sin Categoría',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dirección Fija
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dirección física (Ubicación en Mapa)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  business.address.isNotEmpty
                                      ? business.address
                                      : 'Sin Dirección cargada',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- BOTÓN GUARDAR CAMBIOS (Corregido y consolidado) ---
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Convertimos la lista de XFile elegida localmente a Paths reales de Strings
                            final List<String> pathsToSend =
                                _selectedNewImagesFiles
                                    .map((f) => f.path)
                                    .toList();

                            final success = await businessProvider.updateBusiness(
                              name: _nameController.text.trim(),
                              description: _descriptionController.text.trim(),
                              businessImagesPaths:
                                  pathsToSend, // Pasamos la variable correcta mapeada
                              authToken: authProvider.token ?? '',
                              keptImages: _currentRemoteImages,
                            );

                            if (success) {
                              setState(() {
                                _isImagesInitialized = false;
                                _selectedNewImagesFiles.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '¡Datos de negocio actualizados con éxito!',
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(businessProvider.errorMessage),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Guardar Cambios',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
