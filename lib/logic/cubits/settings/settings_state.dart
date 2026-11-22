part of 'settings_cubit.dart';

class SettingsState {
  final String setting;
  final AdsServer? adsServer;
  final bool disableMenu;

  SettingsState({
    required this.setting,
    required this.adsServer,
    this.disableMenu = true,
  });

  SettingsState copyWith({
    final String? setting,
    final AdsServer? adsServer,
    final bool? disableMenu,
  }) {
    return SettingsState(
      setting: setting ?? this.setting,
      adsServer: adsServer ?? this.adsServer,
      disableMenu: disableMenu ?? this.disableMenu,
    );
  }
}
