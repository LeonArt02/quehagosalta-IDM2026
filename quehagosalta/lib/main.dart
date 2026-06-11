import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/features/map/data/providers/category_provider.dart';
import 'package:quehagosalta/features/map/data/providers/locationProvider.dart';
import 'package:quehagosalta/features/map/data/services/category_services.dart';
import 'package:quehagosalta/features/map/presentation/screens/HomeScreen.dart';
import 'package:quehagosalta/features/map/data/providers/locationProvider.dart';
import 'package:provider/provider.dart';

void main() {
  final apiClient = ApiClient(baseUrl: 'http://127.0.0.1:8000/api/v1');
  final categotyservices = CategoryServices(apiClient);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(categotyservices),
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
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Homescreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
