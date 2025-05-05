import 'package:flutter/material.dart';
import '../resources/colors_manager.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
        required this.onTap,
        required this.btnColor,
        required this.shadowColor,
        this.borderColor,
        this.width,
        this.alignment,
        this.radius,
        this.elevation,
        required this.widget,
        this.height});

  void Function()? onTap;
  Color? btnColor;
  Color? shadowColor;
  Color? borderColor;
  double? height;
  Widget widget;
  double? width;
  double? radius;
  double? elevation;
  AlignmentGeometry?alignment;
  @override
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width ?? MediaQuery.of(context).size.width * .8,
              height ?? MediaQuery.of(context).size.height * .065),
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                radius ?? 25
            ),

            side: BorderSide(
                color: borderColor ?? ColorManager.primary, width: 1), // Added border color
          ),
          shadowColor:shadowColor,
          alignment: alignment ??Alignment.center,elevation: elevation ?? 3
        ),
        onPressed: onTap,
        child: widget

      // Text(
      //   ,
      //   style: TextStyle(color: ColorManager.white, fontSize: 18),
      // ),
    );
  }
}
