import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';
import 'package:quehagosalta/features/categories/data/providers/category_provider.dart';
import 'package:quehagosalta/features/map/data/providers/locationProvider.dart';
import 'package:quehagosalta/features/auth/data/services/auth_service.dart';
import 'package:quehagosalta/features/categories/data/services/category_services.dart';
import 'package:quehagosalta/features/reviews/data/services/review_services.dart';
import 'package:quehagosalta/features/reviews/data/providers/review_provider.dart';
import 'package:quehagosalta/features/business/data/providers/business_provider.dart';
import 'package:quehagosalta/features/business/data/services/bussines_services.dart';
import 'package:quehagosalta/config/routes/app_routes.dart';
import 'package:quehagosalta/core/api/api_config.dart';

void main() {
  final apiClient = ApiClient(baseUrl: ApiConfig.host);
  final categotyservices = CategoryServices(apiClient);
  final bussinesServices = BussinesServices(apiClient);
  final authService = AuthService(apiClient);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(categotyservices),
        ),
        ChangeNotifierProvider(
          create: (_) => BusinessProvider(bussinesServices),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(
          create: (_) => ReviewProvider(ReviewServices(apiClient)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Que Hago Salta',

      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),

      initialRoute: AppRoutes.login,

      routes: AppRoutes.routes,
    );
    /*
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Homescreen(),
    );

     */
  }
}
