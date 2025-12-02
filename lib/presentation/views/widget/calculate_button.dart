import 'package:flutter/material.dart';
import 'package:sagnay_luis_prueba2/utils/themes/schema_color.dart';
import 'package:sagnay_luis_prueba2/utils/themes/typographic.dart';

class CalculateButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CalculateButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: SchemaColor.secondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: Typographic.textTheme.bodyMedium?.copyWith(
          color: SchemaColor.darkTextColor,
        ),
      ),
    );
  }
}
