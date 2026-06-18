import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/map/data/providers/auth_provider.dart';
import 'package:quehagosalta/core/validators/validator.dart';
import 'package:quehagosalta/features/auth/data/services/toast_service.dart';
import 'package:quehagosalta/config/routes/app_routes.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_button.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_textfield.dart';
import 'package:quehagosalta/features/map/data/providers/locationProvider.dart';
import 'package:latlong2/latlong.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isBusiness = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.register(
        firstName: _nameController.text.trim(),
        lastName: _lastnameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        isBusiness: _isBusiness,
      );

      if (!mounted) return;

      if (_isBusiness) {
        ToastService.success('Usuario creado. Ahora registra tu local');
        // Usamos pushReplacementNamed para que no pueda volver a la pantalla de
        // registro de usuario si presiona el botón "Atrás" de Android.
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ToastService.success('Registro exitoso. Por favor, inicia sesión.');
        Navigator.pushReplacementNamed(context, '/home');
        //Navigator.pop(context);
      }
    } catch (e) {
      // Si algo vuelve a fallar, el catch evita que la app se congele y te avisa qué pasó
      print("🚨 Error en el flujo de registro: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
                    const Icon(Icons.person_add, size: 70),
                    const SizedBox(height: 10),
                    const Text(
                      'CREAR CUENTA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ==========================================
                    // SELECTOR DE TIPO DE USUARIO
                    // ==========================================
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isBusiness = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isBusiness
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Turista',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: !_isBusiness
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isBusiness = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _isBusiness
                                      ? Colors.blue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Negocio',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _isBusiness
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ==========================================
                    // CAMPOS DEL FORMULARIO
                    // ==========================================
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _nameController,
                            label: 'Nombre',
                            icon: Icons.badge,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            controller: _lastnameController,
                            label: 'Apellido',
                            icon: Icons.badge_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _phoneController,
                      label: 'Teléfono (Opcional)',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 30),

                    // ==========================================
                    // BOTÓN REGISTRAR
                    // ==========================================
                    CustomButton(
                      text: 'REGISTRARSE',
                      loading: authProvider.isLoading,
                      onPressed: _register,
                    ),
                    const SizedBox(height: 20),

                    // Enlace para volver al Login
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('¿Ya tienes cuenta? Iniciar sesión'),
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
