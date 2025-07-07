import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormFields {
  static Widget buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    IconData? icon,
    String? Function(String?)? validator,
    bool isNumeric = false,
    bool isEnabled = true,
    TextInputType? keyboardType,
    int? maxLines = 1,
    int? minLines,
  }) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      keyboardType:
          keyboardType ??
          (isNumeric ? TextInputType.number : TextInputType.text),
      inputFormatters: isNumeric
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      maxLines: maxLines,
      minLines: minLines,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
            if (isNumeric && !RegExp(r'^\d+$').hasMatch(value)) {
              return 'Solo se permiten números';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  // Dropdown con lista
  static Widget buildDropdownFromList({
    required BuildContext context,
    required String? selectedValue,
    required List<String> items,
    required String label,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor selecciona una opción';
            }
            return null;
          },
    );
  }

  static Widget buildDropdownFromMap({
    required BuildContext context,
    required String? selectedKey,
    required Map<String, String> items,
    required String label,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    IconData? icon,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedKey,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      isExpanded: true,
      items: items.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor selecciona una opción';
            }
            return null;
          },
    );
  }

  static Widget buildDateField({
    required BuildContext context,
    required DateTime? selectedDate,
    required String label,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
              : 'Seleccionar fecha',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selectedDate != null
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}
