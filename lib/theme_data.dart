import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme = FlexThemeData.light(
    useMaterial3: true,
    scheme: FlexScheme.blueM3,
    // subThemesData: FlexSubThemesData(
    //   inputDecoratorBorderType: FlexInputBorderType.outline,
    //   inputDecoratorRadius: 100.0,
    //   inputDecoratorIsFilled: true,
    //   inputDecoratorBorderWidth: 0,
    //   inputDecoratorBackgroundAlpha: 100,
    // ),
  ).copyWith(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.05),
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(width: 0, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(width: 0, color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          width: 2,
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.amber.shade900,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
