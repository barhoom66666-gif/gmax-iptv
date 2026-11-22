part of 'theme_cubit.dart';

/*@immutable
abstract class ThemeState {}*/

class ThemeState {
  final int indexWelcome;

  ThemeState({required this.indexWelcome});

  factory ThemeState.defaultTheme() {
    return ThemeState(
      indexWelcome: 0,
    );
  }
}
