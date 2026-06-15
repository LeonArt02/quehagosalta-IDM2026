import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/features/map/data/providers/auth_provider.dart';
import 'package:quehagosalta/core/validators/validator.dart';
import 'package:quehagosalta/features/map/data/services/toast_service.dart';
import 'package:quehagosalta/config/routes/app_routes.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_button.dart';
import 'package:quehagosalta/features/map/presentation/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      final role = authProvider.role;

      if (role == null) {
        ToastService.error('El usuario no tiene rol');

        return;
      }

      ToastService.success('Login exitoso');

      Navigator.pushReplacementNamed(context, role.route);
    } catch (e) {
      ToastService.error(e.toString());
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
                    const Icon(Icons.person, size: 90),

                    const SizedBox(height: 20),

                    const Text(
                      'INICIAR SESIÓN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

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

                    CustomButton(
                      text: 'INGRESAR',
                      loading: authProvider.isLoading,
                      onPressed: _login,
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },

                      child: const Text('Crear cuenta'),
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
