import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';
import 'package:quehagosalta/features/auth/data/services/toast_service.dart';
import 'package:quehagosalta/features/map/data/models/user_model.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_button.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_textfield.dart';

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({super.key});

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _first_nameController;
  late final TextEditingController _last_nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cuilController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _first_nameController = TextEditingController(text: user?.first_name ?? '');
    _last_nameController = TextEditingController(text: user?.last_name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _cuilController = TextEditingController(text: user?.cuil ?? '');
  }

  bool _isSaving = false;
  bool _loadedInitialData = false;

  @override
  void dispose() {
    _first_nameController.dispose();
    _last_nameController.dispose();
    _phoneController.dispose();
    _cuilController.dispose();
    super.dispose();
  }

  Future<void> _saveProfileChanges(bool isBussines) async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate())
      return;

    final authProvider = context.read<AuthProvider>();
    final String? secureToken = authProvider.token;

    // 🌟 EL BLINDAJE: Si el token es nulo o está vacío, evitamos el crash con el '!'
    if (secureToken == null || secureToken.isEmpty) {
      ToastService.error(
        'Error de sesión: No se encontró un token válido. Vuelve a iniciar sesión.',
      );
      return;
    }
    setState(() => _isSaving = true);

    final String inputfirst_name = _first_nameController.text.trim();
    final String inputlast_name = _last_nameController.text.trim();
    final String inputPhone = _phoneController.text.trim();
    final String? inputCuil = isBussines ? _cuilController.text.trim() : null;

    try {
      await authProvider.updateProfileOnServer(
        first_name: inputfirst_name,
        last_name: inputlast_name,
        phone: inputPhone,
        cuil: inputCuil,
      );
      ToastService.success('¡Perfil actualizado con éxito!');
    } catch (e) {
      ToastService.error('Error al guardar los cambios: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    print("====== 🔍 AUDITORÍA DE MEMORIA EN PROFILE CRÍTICA ======");
    print("User Object completo en memoria es Null?: ${user == null}");
    if (user != null) {
      print("ID del Usuario: '${user.id}' (Tipo: ${user.id.runtimeType})");
      print("Nombre (first_name): '${user.first_name}'");
      print("Apellido (last_name): '${user.last_name}'");
      print("Email: '${user.email}'");
      print("CUIL: '${user.cuil}'");
      print("Foto de Perfil: '${user.profileImage}'");
      print("Cantidad de Roles en la lista: ${user.roles.length}");
      if (user.roles.isNotEmpty) {
        print("Primer Rol Name: '${user.roles.first.name}'");
      }
    }
    print("======================================================");

    final isBussines =
        user?.roles.any((rol) => rol.name == 'business_user') ?? false;

    if (user != null && !_loadedInitialData) {
      _first_nameController.text = user.first_name;
      _last_nameController.text = user.last_name;
      _phoneController.text = user.phone ?? '';
      _cuilController.text = user.cuil ?? '';
      if (user.first_name.isNotEmpty ||
          (isBussines && user.cuil != null && user.cuil!.isNotEmpty)) {
        _loadedInitialData =
            true; // Bloqueamos para que el usuario pueda escribir tranquilo
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isBussines ? 'Panel de control Comercial' : 'Mi Perfil'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: user?.profileImage != null
                    ? NetworkImage(user!.profileImage!)
                    : null,
                child: user?.profileImage == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                user?.email ?? "",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Text(
                'Hola, ${_first_nameController.text.isNotEmpty ? _first_nameController.text : "Usuario"}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _first_nameController,
                label: 'Nombre *',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _last_nameController,
                label: 'Apellido *',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                label: 'Teléfono *',
                icon: Icons.phone,
              ),
              const SizedBox(height: 30),
              if (isBussines) ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _cuilController,
                  label: 'Datos Fiscales (CUIL/CUIT) *',
                  icon: Icons.badge,
                ),
              ],
              const SizedBox(height: 35),
              CustomButton(
                text: 'GUARDAR CAMBIOS',
                loading: _isSaving,
                onPressed: () => _saveProfileChanges(isBussines),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  authProvider.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'CERRAR SESIÓN',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
