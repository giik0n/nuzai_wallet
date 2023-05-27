import 'package:flutter/material.dart';

const COLOR_ACCENT = Color.fromARGB(255, 27, 199, 222);

ThemeData lightTheme = ThemeData(
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.accent),
    fontFamily: 'Fredoka',
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
      color: Colors.transparent,
      elevation: 0,
      actionsIconTheme: IconThemeData(
        color: Color.fromRGBO(40, 40, 40, 1),
      ),
      iconTheme: IconThemeData(
        color: Color.fromRGBO(40, 40, 40, 1),
      ),
    ),
    listTileTheme:
        const ListTileThemeData(tileColor: Color.fromRGBO(245, 244, 248, 1)),
    scaffoldBackgroundColor: Colors.white);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Color.fromRGBO(8, 26, 52, 1),
  fontFamily: 'Fredoka',
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
    actionsIconTheme: IconThemeData(
      color: Color.fromRGBO(40, 40, 40, 1),
    ),
    iconTheme: IconThemeData(
      color: Color.fromRGBO(40, 40, 40, 1),
    ),
  ),
  listTileTheme:
      const ListTileThemeData(tileColor: Color.fromRGBO(28, 46, 80, 1)),
  colorScheme: const ColorScheme.dark(
    secondary: COLOR_ACCENT,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(COLOR_ACCENT)),
  ),
);
