import 'package:flutter/material.dart';

const COLOR_ACCENT = Color.fromARGB(255, 55, 135, 254);

ThemeData lightTheme = ThemeData(
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.accent
  ),

    fontFamily: 'Montserrat',
    textTheme: const TextTheme(
      headline4: TextStyle(color: Colors.black),
    ),
    colorScheme: const ColorScheme.light(
      secondary: COLOR_ACCENT,
      brightness: Brightness.light,
    ),
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(COLOR_ACCENT)),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      actionsIconTheme: IconThemeData(
        color: Color.fromRGBO(40, 40, 40, 1),
      ),
      iconTheme: IconThemeData(
        color: Color.fromRGBO(40, 40, 40, 1),
      ),
    ),
    scaffoldBackgroundColor: Colors.white);

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    secondary: COLOR_ACCENT,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(COLOR_ACCENT)),
  ),
);
