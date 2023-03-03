import 'package:a_2/screens/main_activity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: GoogleFonts.inter().fontFamily,
        appBarTheme: const AppBarTheme(
            elevation: 0,
            color: Colors.transparent,
            toolbarTextStyle: TextStyle(
              color: Colors.black26,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: IconThemeData(color: Colors.black26)),
      ),
      home: const MainActivity(),
    );
  }
}
