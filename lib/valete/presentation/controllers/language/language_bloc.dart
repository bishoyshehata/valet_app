import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_events.dart';
import 'language_state.dart';


class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial(const Locale('en'))) {
    on<ChangeLanguage>((event, emit) {
      emit(LanguageChanged(event.locale));
    });
  }
}