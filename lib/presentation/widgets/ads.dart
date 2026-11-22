part of 'widgets.dart';

void loadInterstitialAd() {
  if (kShowAds) {
    debugPrint("Load InterstitialAd");
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('InterstitialAd is loaded');
            // Keep a reference to the ad so you can show it later.
            ad.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key, required this.adSize, required this.valueKey});

  final AdSize adSize;
  final ValueKey valueKey;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  /// Loads a banner ad.
  void _loadAdMobile() {
    if (!kShowAds) return;
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: widget.adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
          setState(() {
            _isLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  void initState() {
    if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
      _loadAdMobile();
    }
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded && _bannerAd == null) return const SizedBox();
    return SizedBox(
      width: getSize(context).width,
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(
        ad: _bannerAd!,
        key: widget.valueKey,
      ),
    );
  }
}

///******* OPEN APP AD ************

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Load an AppOpenAd.
  void loadAd() {
    debugPrint("Load an AppOpenAd");
    AppOpenAd.load(
      adUnitId: AdHelper.openAppAdUnitId,
      //orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint("Open AppAd Loaded");
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
      request: const AdRequest(),
    );
  }

  ///Show Ads
  void showAdIfAvailable() {
    debugPrint("showAdIfAvailable");
    if (!isAdAvailable) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
  }
}

class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}
