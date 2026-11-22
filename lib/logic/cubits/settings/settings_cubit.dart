import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../../repository/api/api.dart';
import '../../../repository/models/ads.dart';

part 'settings_state.dart';

const platform = MethodChannel('main_activity_channel');

class SettingsCubit extends Cubit<SettingsState> {
  final AuthApi authApi;

  SettingsCubit(this.authApi)
      : super(SettingsState(setting: "loading", adsServer: null));

  void getSettingsCode() async {
    try {
      if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        String data = await platform.invokeMethod('getData');
        debugPrint("DATA: $data");
        emit(state.copyWith(setting: data));
      } else {
        emit(state.copyWith(setting: "null"));
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void getAdsServer() async {
    /* try {
      final result = await authApi.getServerAds();

      if (result != null) {
        emit(state.copyWith(adsServer: result));
      }
    } catch (e) {
      debugPrint("Error: $e");
    }*/
  }

  void disableMenu(bool value) => emit(state.copyWith(disableMenu: value));
}
