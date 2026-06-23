import 'package:flutter/material.dart';
import 'package:quehagosalta/features/map/presentation/screens/loginScreen.dart';
import 'package:quehagosalta/features/map/presentation/screens/registerScreen.dart';
import 'package:quehagosalta/features/map/presentation/screens/HomeScreen.dart';
import 'package:quehagosalta/features/business/screens/businessRegisterPage.dart';
import 'package:quehagosalta/features/business/screens/owner_onboarding_screen.dart';
import 'package:quehagosalta/features/users/screen/profileDashboard.dart';
import 'package:quehagosalta/features/business/screens/businessDashboard.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String homeScreen = '/home';
  static const String profile = '/profileDashboard';
  static const String ownerOnboarding = '/owner_onboarding';
  static const String businessRegister = '/business_register';
  static const String businessDashboard = '/businessDashboard';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    homeScreen: (context) => const Homescreen(),
    profile: (context) => const ProfileDashboard(),
    ownerOnboarding: (context) => const OwnerOnboardingPage(),
    businessRegister: (context) => const BusinessRegisterPage(),
    businessDashboard: (context) => const BusinessDashboardScreen(),
  };
}
