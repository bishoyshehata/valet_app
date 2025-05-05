import 'package:flutter/material.dart';

import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';
import '../resources/values_manager.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.icon,
    this.radius,
    this.labelText,
     this.hintText,
    this.controller,
    this.obscureText,
    this.validator,
    this.suffixIcon,
    this.keyboard,
    this.hintSize,
    this.hintTextColor,
    this.labelSize,
    this.labelTextColor,
    this.backgroundColor,
    this.cursorColor,
    this.textColor,
  });

  Widget? icon;
  Widget? suffixIcon;
  TextInputType? keyboard;
  String? labelText;
  String? hintText;
  TextEditingController? controller;
  bool? obscureText;
  double? radius;
  double? hintSize;
  double? labelSize;
  Color? hintTextColor;
  Color? labelTextColor;
  Color? backgroundColor;
  Color? cursorColor;
  Color? textColor;
  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: textColor ?? ColorManager.white ),
      keyboardType: keyboard,
      controller: controller,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,cursorColor:cursorColor ?? ColorManager.white,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        fillColor: backgroundColor ?? ColorManager.background,
        filled: true,
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 25),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 25),
          borderSide: BorderSide(color: ColorManager.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 25),
          borderSide: BorderSide(color: ColorManager.white,width: 1),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor ?? ColorManager.white,
          fontSize:hintSize,
        ),
        labelText: labelText,
        labelStyle:TextStyle(
          color: labelTextColor ?? ColorManager.white,
          fontSize:labelSize,
        ),

      ),
    );
  }
}
