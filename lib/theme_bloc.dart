import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class ThemeEvent {}

final class ToggleThemeEvent extends ThemeEvent {}

final class InitialThemeEvent extends ThemeEvent {}

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  final SharedPreferences prefs;
  ThemeBloc(ThemeData initialTheme, this.prefs) : super(initialTheme) {
    on<InitialThemeEvent>((event, emit) async {
      //Let's check if we already have theme value saved
      // Emit the saved theme if available or emit light default theme
      //Create an instance of SharedPreferences

      String? savedTheme = prefs.getString('theme');
      ThemeData initialThemeToLoad =
          savedTheme == 'dark' ? ThemeData.dark() : ThemeData.light();
      emit(initialThemeToLoad);
    });
    on<ToggleThemeEvent>((event, emit) async {
      //On every toggle theme event, we also have to save the current theme to shared_preferences.So,
      ThemeData changedTheme =
          state == ThemeData.dark() ? ThemeData.light() : ThemeData.dark();

      prefs.setString(
          'theme', changedTheme == ThemeData.dark() ? 'dark' : 'light');

      emit(changedTheme);
    });
  }
}
  // **BAD**
  // on<Event>((event, emit) {
  //  future.whenComplete(() => emit(...));
  // });

  //  **GOOD**
  // on<Event>((event, emit) async {
  //    await future.whenComplete(() => emit(...));
  // });
