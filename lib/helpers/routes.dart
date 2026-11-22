part of 'helpers.dart';

const String screenSplash = "/";

const String screenDownload = "downloading";

const String screenHome = "home";
const String screenRegister = "register";
const String screenPlaylists = "playlists";
const String screenSettings = "settings";
const String screenAccount = "account";
const String screenMovies = "movies";
const String screenMoviesDetails = "movies-detail";
const String screenSeries = "series";
const String screenSerieDetails = "series-detail";
const String screenSerieSeasons = "series-seasons";
const String screenLive = "live";
const String screenLiveMore = "live-more";

const String screenMoreMovies = "more-movie";
const String screenMoreSeries = "more-series";
const String screenSeriesCategories = "categories-series";

//const String screenPlayerWeb = "player-web";
const String screenPlayerDesktop = "player-desk";
const String playerVideo = "movie-player";
const String livePlayer = "live-player";

const screenYoutube = "youtube";

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: "/",
      name: screenSplash,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, stateAuth) {
            if (stateAuth is AuthLoading) {
              return const Center(child: ProgressRing());
            } else if (stateAuth is AuthSuccess) {
              return SafeArea(
                left: !UniversalPlatform.isDesktopOrWeb,
                right: false,
                top: false,
                bottom: false,
                child: WelcomeScreen(
                  shellContext: _shellNavigatorKey.currentContext,
                  state: state,
                  child: child,
                ),
              );
            }

            return const RegisterPage();
          },
        );
      },
      routes: [
        GoRoute(
          path: '/$screenHome',
          name: screenHome,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: "/$screenSeries",
          name: screenSeries,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const SeriePage(),
        ),
        GoRoute(
          path: "/$screenMoviesDetails",
          name: screenMoviesDetails,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final model = state.extra as ChannelMovie;
            final channelName = state.uri.queryParameters['channel_name'] ?? "";

            return MovieDetailsPage(
                channelMovie: model, channelName: channelName);
          },
        ),
        GoRoute(
          path: "/$screenMoreMovies",
          name: screenMoreMovies,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final id = state.uri.queryParameters['id'] ?? "";
            final name = state.uri.queryParameters['name'] ?? "";
            return MoreMoviesPage(id: id, name: name);
          },
        ),
        GoRoute(
          path: "/$screenMoreSeries",
          name: screenMoreSeries,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final id = state.uri.queryParameters['id'] ?? "";
            final name = state.uri.queryParameters['name'] ?? "";
            return MoreSeriesPage(id: id, name: name);
          },
        ),
        GoRoute(
          path: "/$screenSerieDetails",
          name: screenSerieDetails,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final model = state.extra as ChannelSerie;
            final channelName = state.uri.queryParameters['channel_name'] ?? "";

            return SerieDetailsPage(
              catyName: channelName,
              channelSerie: model,
            );
          },
        ),
        GoRoute(
          path: "/$screenLive",
          name: screenLive,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const LivePage(),
        ),
        GoRoute(
          path: "/$screenLiveMore",
          name: screenLiveMore,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final id = state.uri.queryParameters['id'] ?? "";
            final name = state.uri.queryParameters['name'] ?? "";
            return MoreLivePage(
              id: id,
              name: name,
            );
          },
        ),
        GoRoute(
          path: "/$screenSettings",
          name: screenSettings,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/$screenMovies',
          name: screenMovies,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const MoviePage(),
        ),
        GoRoute(
          path: "/$screenYoutube",
          name: screenYoutube,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) =>
              YoutubeTrailerPage(trailerId: state.extra as String),
        ),
      ],
    ),

    ///OutSide

    GoRoute(
      path: "/$screenSerieSeasons",
      name: screenSerieSeasons,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final season = state.uri.queryParameters['season'] ?? "";
        final image = state.uri.queryParameters['image'] ?? "";
        final episodes = state.extra as List<Episode?>?;

        return SeasonPage(
          season: season,
          episodes: episodes ?? const [],
          image: image,
        );
      },
    ),

    GoRoute(
      path: "/$screenRegister",
      name: screenRegister,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterPage(),
    ),

    GoRoute(
      path: "/$screenDownload",
      name: screenDownload,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DownloadPage(),
    ),

    GoRoute(
      path: "/$playerVideo",
      name: playerVideo,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return MoviePlayerPage(videoModel: state.extra as VideoModel);
      },
    ),

    GoRoute(
      path: "/$livePlayer",
      name: livePlayer,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return LivePlayerPage(videoModel: state.extra as VideoModel);
      },
    ),
  ],
);

String get locationName {
  final RouteMatch lastMatch = router.routerDelegate.currentConfiguration.last;
  final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
      ? lastMatch.matches
      : router.routerDelegate.currentConfiguration;
  final String location = matchList.uri.toString();

  return location;
}
