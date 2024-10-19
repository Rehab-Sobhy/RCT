import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rct/constants/constants.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      background: whiteBackGround,
      primary: primaryColor,
    ),
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: TextTheme(
      bodySmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        // height: 1.5, // Leading point of 24px (24/16)
      ),
      // Label Medium
      labelMedium: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        // height: 1.29, // Leading point of 18px (18/14)
      ),
      // Label Small.
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        //   height: 1.33, // Leading point of 16px (16/12)
      ),
    ),
  );
}
