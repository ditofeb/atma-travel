import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {

  static TextStyle poppinsNormal({required double fontSize, Color? color}) {
    return GoogleFonts.poppins(
      fontWeight: FontWeight.normal,
      fontSize: fontSize,
      color: color ?? Colors.black,
    );
  }

  static TextStyle poppinsBold(
      {required double fontSize, Color? color}) {
    return GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      color: color ?? Colors.black,
    );
  }
}
