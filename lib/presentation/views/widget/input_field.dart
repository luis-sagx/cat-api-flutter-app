import 'package:flutter/material.dart';

class InputFieldU extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const InputFieldU({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: validator,
    );
  }
}
