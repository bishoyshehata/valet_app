import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../resources/colors_manager.dart';

class CustomPhoneField extends StatelessWidget {
  final String? initialCountryCode;
  final String? labelText;
  final double? labelSize;
  final Color? labelTextColor;
  final Color? backgroundColor;
  final Function(PhoneNumber)? onChanged;
  final String? errorText;
  final String? hintText; // في الأعلى

  const CustomPhoneField({
    super.key,
    this.initialCountryCode = 'EG',
    this.labelText,
    this.labelSize,
    this.labelTextColor,
    this.onChanged,
    this.errorText,
    this.hintText,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(

        errorText: errorText, // إظهار رسالة الخطأ إذا كانت موجودة
        fillColor: backgroundColor ??ColorManager.darkGrey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: ColorManager.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: ColorManager.white, width: 1),
        ),

      ),
      initialCountryCode: initialCountryCode,
      countries: [
        Country(
          name: "مصر",
          nameTranslations: {
            "en": "Egypt",
            "ar": "مصر",
          },
          flag: "🇪🇬",
          code: "EG",
          dialCode: "20",
          minLength: 10,
          maxLength: 10,
        ),
        Country(
          name: "السعودية",
          nameTranslations: {
            "en": "Saudi Arabia",
            "ar": "السعودية",
          },
          flag: "🇸🇦",
          code: "SA",
          dialCode: "966",
          minLength: 9,
          maxLength: 9,
        ),
        Country(
          name: "الإمارات العربية",
          nameTranslations: {
            "en": "United Arab Emirates",
            "ar": "الإمارات العربية المتحدة",
          },
          flag: "🇦🇪",
          code: "AE",
          dialCode: "971",
          minLength: 9,
          maxLength: 9,
        ),
        // إضافة باقي الدول وترجمتها للعربية هنا
      ],        dropdownTextStyle: TextStyle(color: ColorManager.white),
      style: TextStyle(color: ColorManager.white),
      cursorColor: ColorManager.white,
      onChanged: onChanged,
    );
  }
}
