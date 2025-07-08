import 'package:flutter/services.dart';

class VaccineColors {
  static const Map<String, Color> colors = {
    'COVID-19': Color(0xFF4CAF50),
    'Influenza': Color(0xFF2196F3),
    'Hepatitis': Color(0xFF9C27B0),
    'Sarampión': Color(0xFFE91E63),
    'Polio': Color(0xFF00BCD4),
    'Tétanos': Color(0xFFFF5722),
    'Varicela': Color(0xFFFFEB3B),
    'Meningitis': Color(0xFF673AB7),
    'Neumococo': Color(0xFF3F51B5),
    'Rotavirus': Color(0xFFFF9800),
  };

  static Color getColorForVaccine(String vaccine) {
    for (var entry in colors.entries) {
      if (vaccine.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return const Color(0xFF607D8B);
  }
}
