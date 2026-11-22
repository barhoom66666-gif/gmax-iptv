class AdsServer {
  final String status;
  final String androidBannerAdmob;
  final String androidBannerLargeAdmob;
  final String androidInterstitialAdmob;
  final String iosBannerAdmob;
  final String iosBannerLargeAdmob;
  final String iosInterstitialAdmob;
  final String androidBannerFacebook;
  final String androidNativeFacebook;
  final String androidInterstitialFace;
  final String iosBannerFacebook;
  final String iosNativeFacebook;
  final String iosInterstitialFace;
  final String applovinId;
  final String androidBannerAppLovin;
  final String androidBannerLargeAppLovin;
  final String androidInterstitialAppLovin;

  AdsServer({
    required this.status,
    required this.androidBannerAdmob,
    required this.androidBannerLargeAdmob,
    required this.androidInterstitialAdmob,
    required this.iosBannerAdmob,
    required this.iosBannerLargeAdmob,
    required this.iosInterstitialAdmob,
    required this.androidBannerFacebook,
    required this.androidNativeFacebook,
    required this.androidInterstitialFace,
    required this.iosBannerFacebook,
    required this.iosNativeFacebook,
    required this.iosInterstitialFace,
    required this.applovinId,
    required this.androidBannerAppLovin,
    required this.androidBannerLargeAppLovin,
    required this.androidInterstitialAppLovin,
  });

  AdsServer.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        androidBannerAdmob = json['android_bannerAdmob'] as String,
        androidBannerLargeAdmob = json['android_bannerLargeAdmob'] as String,
        androidInterstitialAdmob = json['android_interstitialAdmob'] as String,
        iosBannerAdmob = json['ios_bannerAdmob'] as String,
        iosBannerLargeAdmob = json['ios_bannerLargeAdmob'] as String,
        iosInterstitialAdmob = json['ios_interstitialAdmob'] as String,
        androidBannerFacebook = json['android_bannerFacebook'] as String,
        androidNativeFacebook = json['android_nativeFacebook'] as String,
        androidInterstitialFace =
            json['android_interstitialFacebook'] as String,
        iosBannerFacebook = json['ios_bannerFacebook'] as String,
        iosNativeFacebook = json['ios_nativeFacebook'] as String,
        iosInterstitialFace = json['ios_interstitialFacebook'] as String,
        applovinId = json['applovin_id'] as String,
        androidBannerAppLovin = json['android_bannerAppLovin'] as String,
        androidBannerLargeAppLovin =
            json['android_bannerLargeAppLovin'] as String,
        androidInterstitialAppLovin =
            json['android_interstitialAppLovin'] as String;

  Map<String, dynamic> toJson() => {
        'status': status,
        'android_bannerAdmob': androidBannerAdmob,
        'android_bannerLargeAdmob': androidBannerLargeAdmob,
        'android_interstitialAdmob': androidInterstitialAdmob,
        'ios_bannerAdmob': iosBannerAdmob,
        'ios_bannerLargeAdmob': iosBannerLargeAdmob,
        'ios_interstitialAdmob': iosInterstitialAdmob,
        'android_bannerFacebook': androidBannerFacebook,
        'android_nativeFacebook': androidNativeFacebook,
        'android_interstitialFace': androidInterstitialFace,
        'ios_bannerFacebook': iosBannerFacebook,
        'ios_nativeFacebook': iosNativeFacebook,
        'ios_interstitialFace': iosInterstitialFace,
        'applovin_id': applovinId,
        'android_bannerAppLovin': androidBannerAppLovin,
        'android_bannerLargeAppLovin': androidBannerLargeAppLovin,
        'android_interstitialAppLovin': androidInterstitialAppLovin
      };
}
