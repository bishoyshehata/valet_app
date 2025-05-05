import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignnment,
      maxLines: noOfLines,
      overflow: overFlow,
      style: getFontStyle(
        fontFamily: fontFamily,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
      ),
    );
  }
}
