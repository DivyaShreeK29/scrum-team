import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appLightTheme = ThemeData(
    primaryColor: const Color(0xff103288),
    backgroundColor: const Color(0xffE7EAF2),
    dividerColor: Colors.blueGrey,
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.blue[100]); //const Color(0xfff0f2f5));

ThemeData applicationTheme(context) {
  final textTheme = Theme.of(context).textTheme;
  return ThemeData(
      primaryColor: const Color(0xff193D9F),
      selectedRowColor: Colors.blueGrey,
      dividerColor: Colors.grey[300],
      highlightColor: const Color(0xffFFD6DA),
      primaryColorDark: const Color(0xff07144B),
      backgroundColor: const Color(0xffF6F6F6),
      secondaryHeaderColor: const Color(0xff2B3D88),
      textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          caption: GoogleFonts.lato(
              textStyle: textTheme.caption,
              letterSpacing: 0.4,
              fontSize: 12,
              fontWeight: FontWeight.normal),
          bodyText1: GoogleFonts.lato(
              textStyle: textTheme.bodyText1,
              letterSpacing: 0.5,
              fontSize: 16,
              fontWeight: FontWeight.normal),
          bodyText2: GoogleFonts.lato(
              textStyle: textTheme.bodyText2,
              letterSpacing: 0.25,
              fontSize: 14,
              fontWeight: FontWeight.normal),
          subtitle1: GoogleFonts.montserrat(
              textStyle: textTheme.subtitle1,
              letterSpacing: 0.15,
              fontSize: 16,
              fontWeight: FontWeight.normal),
          subtitle2: GoogleFonts.montserrat(
              textStyle: textTheme.subtitle2,
              letterSpacing: 0.1,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          headline1: GoogleFonts.montserrat(
              textStyle: textTheme.headline1,
              letterSpacing: -1.5,
              fontSize: 96,
              fontWeight: FontWeight.w300),
          headline2: GoogleFonts.montserrat(
              textStyle: textTheme.headline2,
              letterSpacing: -0.5,
              fontSize: 60,
              fontWeight: FontWeight.w300),
          headline3: GoogleFonts.montserrat(
              textStyle: textTheme.headline3,
              letterSpacing: 0.0,
              fontSize: 48,
              fontWeight: FontWeight.normal),
          headline4: GoogleFonts.montserrat(
              textStyle: textTheme.headline4,
              letterSpacing: 0.25,
              fontSize: 34,
              fontWeight: FontWeight.normal),
          headline5: GoogleFonts.montserrat(
              textStyle: textTheme.headline5,
              letterSpacing: 0.0,
              fontSize: 24,
              fontWeight: FontWeight.normal),
          headline6: GoogleFonts.montserrat(
              textStyle: textTheme.headline6,
              letterSpacing: 0.15,
              fontSize: 20,
              fontWeight: FontWeight.w500),
          button: GoogleFonts.lato(
              textStyle: textTheme.button,
              letterSpacing: 1.25,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white),
          overline: GoogleFonts.montserrat(
              textStyle: textTheme.overline,
              letterSpacing: 1.5,
              fontSize: 10,
              fontWeight: FontWeight.normal)));
}

var colorThemeData = {
  "primaryColor": Color(0X193D9F),
  "secondayColor": const Color(0xff29D890),
  'tertiaryColor': const Color(0xffBBB7B7),
  "primaryTextColor": const Color(0xff444444),
  "secondayTextColor": Colors.white,
  "primaryIconColor": const Color(0xff0DC6B8),
  // "hintTextColor":HexColor('#C5CCD6'),
  "accentColor": Colors.grey,
  "transparentColor": Colors.transparent,
  "snackbarTextColor": Colors.white,
  "backgroundColor": Colors.white,
  "buttonTextColor": Colors.white,
};

// ignore: camel_case_types
class dimensions {
  static const double standard_parent_widget_spacing = 32.0;
  static const double standard_child_widget_spacing = 16.0;
  static const double standard_spacing_factor_in_ten = 10.0;
  static const double standard_spacing_factor_in_eight = 8.0;
  static const double standard_spacing_factor_in_six = 6.0;
  static const double standard_spacing_factor_in_four = 4.0;
  static const double standard_spacing_factor_in_two = 2.0;
  static const double standard_mobile_icon_size = 28.0;
  static const double standard_web_icon_size = 32.0;
  static const double standard_border_radius = 32.0;
  static const double standard_header6_font_size = 20.0;
  static const double standard_header5_font_size = 24.0;
  static const double standard_header4_font_size = 34.0;
  static const double standard_bodyText1_font_size = 16.0;
  static const double standard_bodyText2_font_size = 14.0;
  static const double standard_bodyText3_font_size = 12.0;
  static const double standard_padding = 16.0;
  static const double standard_vertical_padding = 24.0;
}
