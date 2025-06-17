import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/l10n/app_locale.dart';
import '../resources/colors_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';

class AlertDialogService {
  // Singleton instance
  static final AlertDialogService _instance = AlertDialogService._internal();

  factory AlertDialogService() => _instance;

  AlertDialogService._internal();

  Future<bool?> showAlertDialog(
      BuildContext context, {
        required String title,
        required String message,
        String? positiveButtonText,
        String? negativeButtonText,
        VoidCallback? onPositiveButtonPressed,
        VoidCallback? onNegativeButtonPressed,
        bool? dismissible,
      }) async {
    final String positiveText = positiveButtonText ?? AppLocalizations.of(context)!.yes;
    final String negativeText = negativeButtonText ?? AppLocalizations.of(context)!.no;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: dismissible ?? false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: ColorManager.grey,

            title: Text(
              title,
              style:GoogleFonts.cairo(
                fontSize: FontSize.s17,
                fontWeight: FontWeight.bold,
                color: ColorManager.white,
              ),
            ),
            content: Text(
              message,
              style:GoogleFonts.cairo(
                fontSize: FontSize.s14,
                fontWeight: FontWeight.bold,
                color: ColorManager.white,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  onNegativeButtonPressed?.call();
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  negativeText,
                  style:GoogleFonts.cairo(
                    fontSize: FontSize.s14,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.lightGrey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  onPositiveButtonPressed?.call();
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  positiveText,
                  style:GoogleFonts.cairo(
                    fontSize: FontSize.s14,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
