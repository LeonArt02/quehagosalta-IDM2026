import 'package:flutter/material.dart';
import 'package:quehagosalta/features/map/presentation/screens/loginScreen.dart';
import 'package:quehagosalta/features/map/presentation/screens/registerScreen.dart';
import 'package:quehagosalta/features/map/presentation/screens/HomeScreen.dart';
import 'package:quehagosalta/features/map/presentation/screens/businessRegisterPage.dart';

class AppRoutes {

  static const String login = '/login';

  static const String register = '/register';

  static const String homeScreen =
      '/home';

  static const String profile =
      '/profile';
  static const String businessRegister = '/business_register';

  static Map<String, WidgetBuilder> routes = {

    login: (_) => const LoginPage(),

    register: (_) => const RegisterPage(),

    homeScreen: (_) =>
        const Homescreen(),
    businessRegister: (_) => const BusinessRegisterPage(),
/* 
    profile: (_) =>
        const ProfilePage(),

        */
  };
}