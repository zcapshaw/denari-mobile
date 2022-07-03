import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme = ThemeData(
  primarySwatch: Colors.blueGrey,
  appBarTheme: AppBarTheme(
      color: Colors.blueGrey[500],
      iconTheme: IconThemeData(
        color: Colors.grey[700],
      ), systemOverlayStyle: SystemUiOverlayStyle.dark),
  textTheme: TextTheme(
    headline1: GoogleFonts.manrope(
      fontWeight: FontWeight.w600,
      color: Colors.grey[700],
      fontSize: 24,
    ),
    headline3: GoogleFonts.manrope(
      fontWeight: FontWeight.w600,
      color: Colors.grey[700],
    ),
    headline4: GoogleFonts.manrope(
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1A6978),
      fontSize: 36,
    ),
    headline6: GoogleFonts.manrope(
      fontWeight: FontWeight.w700,
      color: Colors.blueGrey[900],
      fontSize: 20,
      letterSpacing: 0.4,
    ),
    bodyText1: GoogleFonts.manrope(
      color: Colors.blueGrey[900],
      fontWeight: FontWeight.w400,
      fontSize: 20.0,
      letterSpacing: 0.4,

    ),
    bodyText2: GoogleFonts.manrope(
      color: Colors.grey[700],
    ),
    caption: GoogleFonts.manrope(
      color: Colors.grey[400],
      fontSize: 12,
    ),
    subtitle1: GoogleFonts.manrope(
      color: Colors.grey[700],
    ),
    subtitle2: GoogleFonts.manrope(
      color: Colors.grey[600],
      fontSize: 16,
      letterSpacing: 0.4,
      height: 1.5,
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);