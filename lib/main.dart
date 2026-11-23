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
          child: child!,
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
