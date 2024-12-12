import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  ThemeData light = ThemeData(
      canvasColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff5D9CEC), primary: Color(0XFF5D9CEC)),
      useMaterial3: false,
      scaffoldBackgroundColor: Color(0xffDFECDB),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff5D9CEC),
        toolbarHeight: 100,
        titleTextStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xff5D9CEC),
        splashColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white, width: 4),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ));
  ThemeData dark = ThemeData(
      canvasColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff5D9CEC), primary: Color(0XFF5D9CEC)),
      useMaterial3: false,
      scaffoldBackgroundColor: Color(0xff060e1e),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff5D9CEC),
        toolbarHeight: 100,
        titleTextStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xff5D9CEC),
        splashColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: StadiumBorder(
          side: BorderSide(color: Color(0xff141922), width: 4),
        ),
      ),
      cardTheme: CardTheme(
        color: Color(0xff141922),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ));
}
