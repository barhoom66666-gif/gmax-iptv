part of 'helpers.dart';

abstract class AdHelper {
  static String get bannerAdUnitId {
    if (UniversalPlatform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (UniversalPlatform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      return '';
    }
  }

  static String get interstitialAdUnitId {
    if (UniversalPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (UniversalPlatform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      return '';
    }
  }

  static String get openAppAdUnitId {
    if (UniversalPlatform.isAndroid) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else if (UniversalPlatform.isIOS) {
      return "ca-app-pub-3940256099942544/5662855259";
    } else {
      return '';
    }
  }
}
