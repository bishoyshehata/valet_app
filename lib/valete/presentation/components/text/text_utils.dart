import 'package:flutter/material.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';

import 'get_font_style.dart';

class TextUtils extends StatelessWidget {
  final String text;
  final TextAlign? alignnment;
  final String? fontFamily;
  final double? fontSize;
  final int? noOfLines;
  final Color? color;
  final TextOverflow? overFlow;
  final FontWeight? fontWeight;
  final TextDirection? textDirection;

  const TextUtils({
    super.key,
    required this.text,
    this.alignnment,
    this.fontFamily,
    this.fontSize,
    this.noOfLines,
    this.color,
    this.overFlow,
    this.fontWeight,
    this.textDirection
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignnment,
      maxLines: noOfLines,
      overflow: overFlow,
      textDirection: textDirection,
      style: getFontStyle(
        fontFamily: fontFamily,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? ColorManager.primary,
      ),
    );
  }
}
