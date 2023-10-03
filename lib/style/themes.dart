import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: const Color(0xff5D9CEC),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    color: Color(0xff5D9CEC),
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w700
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0,
    selectedItemColor: Color(0xff5D9CEC),
    unselectedItemColor: Color(0xffC8C9CB),
    selectedIconTheme: IconThemeData(
      color:  Color(0xff5D9CEC),
    ),
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w700
    ),
    labelSmall: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w400
    ) ,
    bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w700
    ),
    titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 30 ,
        fontWeight: FontWeight.w700
    ),
  ),

);

ThemeData darkTheme = ThemeData(
  primaryColor: const Color(0xff5D9CEC),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    color: Color(0xff5D9CEC),
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w700
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0,
    selectedItemColor: Color(0xff5D9CEC),
    unselectedItemColor: Color(0xffC8C9CB),
    selectedIconTheme: IconThemeData(
      color:  Color(0xff5D9CEC),
    ),
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff060E1E),
    primary: const Color(0xff060E1E),
    background: const Color(0xff060E1E),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w600
    ),
    labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400
    ) ,
    bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w400),
    titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 30 ,
        fontWeight: FontWeight.w700
    ),
  ),
);