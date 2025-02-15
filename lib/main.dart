import 'package:fantasy_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/player.dart';
import 'screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Algerian Fantasy",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Change Font for All Text
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}
