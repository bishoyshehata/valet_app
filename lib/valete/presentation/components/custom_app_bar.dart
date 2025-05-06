import 'package:flutter/material.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import '../resources/font_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? titleColor;
  final double elevation;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.titleColor,
    this.actions,
    this.backgroundColor,
    this.shadowColor,
    this.elevation = 1,
    this.centerTitle = true,

  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      shadowColor: shadowColor ?? Colors.white,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.black,
      leading: leading,
      actions: actions,
      title: TextUtils(
        text: title,
        color: titleColor,
        fontWeight: FontWeightManager.semiBold,
        overFlow: TextOverflow.ellipsis,
        noOfLines: 1,
        fontFamily: 'cairo',
        fontSize: FontSize.s20,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
