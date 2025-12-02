import 'package:flutter/material.dart';
import 'schema_color.dart';

class ButtonThemeApp {
  static final primaryButtonStyle = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: SchemaColor.primaryColor,
      foregroundColor: SchemaColor.lightTextColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shadowColor: SchemaColor.accentColor.withOpacity(0.25),
      elevation: 3,
    ),
  );

  static final secondaryButtonStyle = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: SchemaColor.darkTextColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: SchemaColor.accentColor, width: 2),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}
