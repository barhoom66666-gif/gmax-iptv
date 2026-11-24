import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

//import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mbark_iptv/logic/cubits/categories/categories_cubit.dart';
import 'package:mbark_iptv/repository/api/api.dart';
import 'package:media_kit/media_kit.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:system_theme/system_theme.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

import 'helpers/helpers.dart';
import 'logic/blocs/auth/auth_bloc.dart';

import 'logic/blocs/download/download_bloc.dart';
import 'logic/blocs/random/random_movie_bloc.dart';
import 'logic/cubits/favorites/favorites_cubit.dart';

import 'logic/cubits/search/search_cubit.dart';
import 'logic/cubits/settings/settings_cubit.dart';
import 'logic/cubits/theme/theme_cubit.dart';
import 'logic/cubits/watch/watching_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    MediaKit.ensureInitialized();
  } catch (e) {
    debugPrint("MediaKit init error: $e");
  }
  if (UniversalPlatform.isWindows || UniversalPlatform.isLinux) {
    sqfliteFfiInit();
  }

  try {
    // if it's not on the web, windows or android, load the accent color
    if ([
      TargetPlatform.windows,
      TargetPlatform.macOS,
      TargetPlatform.android,
    ].contains(defaultTargetPlatform)) {
      await SystemTheme.accentColor.load();
      SystemTheme.accentColor.load();
    }

    if (UniversalPlatform.isDesktop) {
      await WindowManager.instance.ensureInitialized();
      windowManager.waitUntilReadyToShow().then((_) async {
        await windowManager.setTitle(kAppName);

        await windowManager.setBackgroundColor(kBackgroundScaffold);
        await windowManager.setSize(const Size(1000, 600));
        await windowManager.setMinimumSize(const Size(1000, 600));
        await windowManager.setPreventClose(false);
        await windowManager.setSkipTaskbar(false);

        await windowManager.center();
        await windowManager.show();
      });
    }

    try {
      if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
        //Initial Ads
        MobileAds.instance.initialize();

        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      }
    } catch (e) {
      debugPrint("MAIN1 Error: $e");
    }

    runApp(MyApp(
      iptv: IpTvApi(),
      authApi: AuthApi(),
      moviesLocale: MoviesLocale(),
      liveLocale: LiveLocale(),
      tvSHowsLocale: TvSHowsLocale(),
      favoriteLocale: FavoriteLocale(),
      watchingLocale: WatchingLocale(),
    ));
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("MAIN2 Error: $e"),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  final IpTvApi iptv;
  final AuthApi authApi;

  final MoviesLocale moviesLocale;
  final LiveLocale liveLocale;
  final TvSHowsLocale tvSHowsLocale;
  final FavoriteLocale favoriteLocale;
  final WatchingLocale watchingLocale;

  const MyApp(
      {super.key,
      required this.iptv,
      required this.authApi,
      required this.moviesLocale,
      required this.liveLocale,
      required this.tvSHowsLocale,
      required this.favoriteLocale,
      required this.watchingLocale});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(authApi),
        ),
        BlocProvider<FavoritesCubit>(
          create: (BuildContext context) => FavoritesCubit(favoriteLocale),
        ),
        BlocProvider<SettingsCubit>(
          create: (BuildContext context) => SettingsCubit(authApi),
        ),
        BlocProvider<SearchCubit>(
          create: (BuildContext context) => SearchCubit(),
        ),
        BlocProvider<DownloadBloc>(
          create: (context) => DownloadBloc(
            api: iptv,
            liveLocale: liveLocale,
            moviesLocale: moviesLocale,
            seriesLocale: tvSHowsLocale,
          ),
        ),
        BlocProvider<WatchingCubit>(
          create: (BuildContext context) => WatchingCubit(watchingLocale),
        ),
        BlocProvider<RandomMovieBloc>(
          create: (BuildContext context) => RandomMovieBloc(),
        ),
        BlocProvider<CategoriesCubit>(
          create: (BuildContext context) => CategoriesCubit(),
        ),
      ],
      child: FluentApp.router(
        title: kAppName,
        debugShowCheckedModeBanner: false,
        darkTheme: FluentThemeData(
          brightness: Brightness.dark,
          accentColor: kColorPrimary.toAccentColor(),
          visualDensity: VisualDensity.standard,
          scaffoldBackgroundColor: kBackgroundScaffold,
          navigationPaneTheme: const NavigationPaneThemeData(
            backgroundColor: kBackgroundScaffold,
            highlightColor: kColorPrimaryDark,
          ),
          fontFamily: kFontFamily,
        ),
        themeMode: ThemeMode.dark,
        theme: FluentThemeData(
          accentColor: kColorPrimary.toAccentColor(),
          visualDensity: VisualDensity.standard,
          scaffoldBackgroundColor: kBackgroundScaffold,
          fontFamily: kFontFamily,
        ),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: VipPinLockGate(child: child!),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}

class VipPinLockGate extends StatefulWidget {
  final Widget child;
  const VipPinLockGate({super.key, required this.child});

  @override
  State<VipPinLockGate> createState() => _VipPinLockGateState();
}

class _VipPinLockGateState extends State<VipPinLockGate> {
  static const String _correctPin = "2026";
  bool _unlocked = false;
  String _entered = "";
  bool _hasError = false;

  void _onDigit(String d) {
    if (_entered.length >= 4) return;
    setState(() {
      _hasError = false;
      _entered += d;
    });
    if (_entered.length == 4) {
      if (_entered == _correctPin) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              _unlocked = true;
            });
          }
        });
      } else {
        Future.delayed(const Duration(milliseconds: 250), () {
          if (mounted) {
            setState(() {
              _hasError = true;
              _entered = "";
            });
          }
        });
      }
    }
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    setState(() {
      _hasError = false;
      _entered = _entered.substring(0, _entered.length - 1);
    });
  }

  Widget _buildKey(String label, {VoidCallback? onTap, bool isGold = false}) {
    return HoverButton(
      onPressed: onTap ?? () => _onDigit(label),
      builder: (context, states) {
        final isFocused = states.isFocused || states.isHovering;
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: isGold || isFocused
                ? const LinearGradient(
                    colors: [Color(0xFFE5C158), Color(0xFF9A711C)],
                  )
                : null,
            color: (isGold || isFocused) ? null : const Color(0xCC1E2933),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isFocused
                  ? const Color(0xFFFFFFFF)
                  : const Color(0x66D5B055),
              width: isFocused ? 2.2 : 1.2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: kFontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: (isGold || isFocused)
                  ? const Color(0xFF090C10)
                  : const Color(0xFFFCE38A),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked) {
      return widget.child;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF070A0E),
              Color(0xFF151E27),
              Color(0xFF261C0B),
              Color(0xFF090C10),
            ],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 680, maxHeight: 330),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xD9161F27),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0x88D5B055),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xA6000000),
                  blurRadius: 28,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                // Right Side (in RTL): Logo, Title, PIN Dots
                Expanded(
                  flex: 11,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          kIconSplash,
                          width: 82,
                          height: 82,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "🔒 Alzaabi TV — تطبيق خاص",
                        style: styleTitle.copyWith(
                          fontSize: 17,
                          color: const Color(0xFFFCE38A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _hasError
                            ? "❌ الرمز السري غير صحيح، حاول مرة أخرى"
                            : "أدخل الرمز السري المكون من 4 أرقام للدخول",
                        style: styleBody.copyWith(
                          fontSize: 12,
                          color: _hasError
                              ? const Color(0xFFFF6B6B)
                              : const Color(0xFFCFD6DC),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            final filled = index < _entered.length;
                            return Container(
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: filled
                                    ? const Color(0xFFE5C158)
                                    : const Color(0xFF0E1318),
                                border: Border.all(
                                  color: _hasError
                                      ? const Color(0xFFFF6B6B)
                                      : const Color(0xFFD5B055),
                                  width: 2,
                                ),
                                boxShadow: filled
                                    ? [
                                        const BoxShadow(
                                          color: Color(0x66E5C158),
                                          blurRadius: 8,
                                        )
                                      ]
                                    : null,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Left Side (in RTL): 3x4 Numeric Keypad
                Expanded(
                  flex: 12,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildKey("1")),
                              const SizedBox(width: 8),
                              Expanded(child: _buildKey("2")),
                              const SizedBox(width: 8),
                              Expanded(child: _buildKey("3")),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildKey("4")),
                              const SizedBox(width: 8),
                              Expanded(child: _buildKey("5")),
                              const SizedBox(width: 8),
                              Expanded(child: _buildKey("6")),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildKey("7")),
                              const SizedBox(width: 8),
                              Expanded(child: _buildKey("8")),
                              const SizedBox(width: 8),
                              Expanded(child: _buildKey("9")),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildKey(
                                  "⌫",
                                  onTap: _onBackspace,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: _buildKey("0")),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildKey(
                                  "C",
                                  isGold: true,
                                  onTap: () {
                                    setState(() {
                                      _entered = "";
                                      _hasError = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
