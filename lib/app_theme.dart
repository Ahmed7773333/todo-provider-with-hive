import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color blueColor = const Color(0xFF5D9CEC);
  static Color lightColor = const Color(0xFFDFECDB);
  static Color darkColor = const Color(0xFF060E1E);
  static Color redColor = const Color(0xFFEC4B4B);
  static Color blackColor = const Color(0xFF141922);
  static Color greenColor = const Color(0xFF61E757);
  static Color grayColor = const Color(0xE8CDCACA);
  static Color iconColor = const Color(0xffC8C9CB);
  static ThemeData lightTheme = ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    bottomAppBarTheme: const BottomAppBarTheme(
        height: 85,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.white),
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.poppins(
        color: blackColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: GoogleFonts.inter(
        color: blackColor,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: lightColor,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: GoogleFonts.roboto(
        color: blackColor,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.23,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: blackColor),
    bottomAppBarTheme: BottomAppBarTheme(
        height: 85,
        shape: const CircularNotchedRectangle(),
        color: blackColor,
        elevation: 5,
        shadowColor: blueColor),
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.poppins(
        color: lightColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: GoogleFonts.inter(
        color: lightColor,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: darkColor,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: GoogleFonts.roboto(
        color: lightColor,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.23,
      ),
    ),
  );
}
