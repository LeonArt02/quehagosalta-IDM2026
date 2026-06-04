import 'package:flutter/material.dart';
import 'package:quehagosalta/features/map/presentation/widgets/MapaBaseWidget.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QueHagoSalta',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: const MapBaseWidget(),
    );
  }
}
