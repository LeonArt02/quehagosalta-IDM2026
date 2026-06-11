import 'package:flutter/material.dart';

extension IconMapperExtension on String? {
  // Esto hace que puedas escribir directo: category.iconKey.toIcon()
  IconData toIcon() {
    switch (this) {
      case 'restaurant_icon':
        return Icons.local_restaurant;
      case 'event_icon':
        return Icons.local_airport;
      case 'coffe_icon':
        return Icons.local_cafe;
      case 'bar_icon':
        return Icons.local_bar;
      case 'pena_icon':
        return Icons.music_note;
      default:
        return Icons.category;
    }
  }
}
