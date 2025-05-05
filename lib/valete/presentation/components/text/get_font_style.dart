import 'dart:ui';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getFontStyle({
  required String? fontFamily,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  switch (fontFamily?.toLowerCase()) {
    case 'cairo':
      return GoogleFonts.cairo(
          fontSize: fontSize, fontWeight: fontWeight, color: color);
    case 'lateef':
      return GoogleFonts.lateef(
          fontSize: fontSize, fontWeight: fontWeight, color: color);
    case 'modak':
      return GoogleFonts.modak(
          fontSize: fontSize, fontWeight: fontWeight, color: color);
  // أضف خطوطًا أخرى حسب الحاجة
    default:
      return GoogleFonts.cairo( // الافتراضي
          fontSize: fontSize, fontWeight: fontWeight, color: color);
  }
}
