
import 'package:easy_life/splash_screen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(
MaterialApp(
  theme: ThemeData(primaryColor: Colors.red, accentColor: Colors.white),
    debugShowCheckedModeBanner: false,
  home: SplashScreen(),
),
  );
}
