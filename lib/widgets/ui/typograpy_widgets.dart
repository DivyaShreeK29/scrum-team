import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Contains all the functions to get the UI components

Text heading6(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.heading6, color: color);
}

Text heading420(
    {required context, required String text, Color color: Colors.black}) {
  // String reverse = text.split("").reversed.join();
  return _getStyledText(
      text: text, textStyle: TextStyles.heading6, color: color);
}

Text heading5(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.heading5, color: color);
}

Text heading4(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.heading4, color: color);
}

Text heading3(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.heading3, color: color);
}

Text heading2(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.heading2, color: color);
}

Text heading1(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.heading1, color: color);
}

Text subtitle1(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.subtitle1, color: color);
}

Text subtitle2(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.subtitle2, color: color);
}

Text body2(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(text: text, textStyle: TextStyles.body2, color: color);
}

Text body1(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(text: text, textStyle: TextStyles.body1, color: color);
}

Text caption(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.caption, color: color);
}

Text overline(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(
      text: text, textStyle: TextStyles.overline, color: color);
}

Text buttonText(
    {required context, required String text, Color color: Colors.black}) {
  return _getStyledText(text: text, textStyle: TextStyles.button, color: color);
}

Text _getStyledText(
    {required text, required TextStyle? textStyle, color: Colors.black}) {
  return Text(
    text,
    style: textStyle?.copyWith(
      color: color,
    ),
  );
}

class TextStyles {
  static var _headingFont = GoogleFonts.poppins;
  static var _bodyFont = GoogleFonts.poppins;

  static TextStyle button = _bodyFont(
    //letterSpacing: 1.25,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle caption = _bodyFont(
      // letterSpacing: 0.4,
      fontSize: 12,
      fontWeight: FontWeight.normal);

  static TextStyle overline = _headingFont(
      //letterSpacing: 1.5,
      fontSize: 10,
      fontWeight: FontWeight.normal);

  static TextStyle body2 = _bodyFont(
    // letterSpacing: 1.25,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body1 = _headingFont(
      // letterSpacing: 0.5,
      fontSize: 16,
      fontWeight: FontWeight.normal);

  static TextStyle subtitle2 = _headingFont(
      letterSpacing: 0.1, fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle subtitle1 = _headingFont(
      letterSpacing: 0.15, fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle heading1 = _headingFont(
      letterSpacing: -1.5, fontSize: 96, fontWeight: FontWeight.w300);

  static TextStyle heading2 = _headingFont(
      letterSpacing: -0.5, fontSize: 60, fontWeight: FontWeight.w300);

  static TextStyle heading3 = _headingFont(
      letterSpacing: 0.0, fontSize: 48, fontWeight: FontWeight.normal);

  static TextStyle heading4 = _headingFont(
      letterSpacing: 0.25, fontSize: 34, fontWeight: FontWeight.normal);

  static TextStyle heading5 = _headingFont(
      letterSpacing: 0.0, fontSize: 24, fontWeight: FontWeight.normal);

  static TextStyle heading6 = _headingFont(
      letterSpacing: 0.15, fontSize: 20, fontWeight: FontWeight.w500);
}
