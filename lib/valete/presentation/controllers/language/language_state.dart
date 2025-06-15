import 'package:flutter/material.dart';

abstract class LanguageState {}

class LanguageInitial extends LanguageState {
  final Locale locale;
  LanguageInitial(this.locale);
}

class LanguageChanged extends LanguageState {
  final Locale locale;
  LanguageChanged(this.locale);
}