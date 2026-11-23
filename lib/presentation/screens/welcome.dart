part of 'screens.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen(
      {super.key, required this.child, this.shellContext, this.state});

  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState? state;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  int topIndex = 0;

  @override
  void initState() {
    initialBlocs(context);
    super.initState();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final bool disableMenu = state.disableMenu;

        return NavigationView(
          key: viewKey,
          appBar: const NavigationAppBar(
            title: AppBarMain(),
            automaticallyImplyLeading: false,
            backgroundColor: kBackgroundScaffold,
          ),
          paneBodyBuilder: (item, child) {
            final name =
                item?.key is ValueKey ? (item!.key as ValueKey).value : null;
            return FocusTraversalGroup(
              key: ValueKey('body$name'),
              child: widget.child,
            );
          },
          pane: NavigationPane(
              selected: topIndex,
              onChanged: (index) {
                if (disableMenu) return;
                loadInterstitialAd();
                debugPrint("change index: $index");
                context.read<SearchCubit>().addSearch("", index, false);
                if (index != 4) {
                  setState(() => topIndex = index);
                }
              },
              displayMode: PaneDisplayMode.compact,
              size: const NavigationPaneSize(openMaxWidth: 120),
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.home),
                  title: const Text('الرئيسية / Home',
                      style: TextStyle(
                        fontFamily: kFontFamily,
                      )),
                  body: const SizedBox.shrink(),
                  onTap: () {
                    if (disableMenu) return;
                    context.read<SearchCubit>().addSearch("", 0, false);

                    if (locationName != screenHome) {
                      router.pushNamed(screenHome);
                    }
                  },
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.my_movies_t_v),
                  title: const Text('الأفلام / Movies',
                      style: TextStyle(
                        fontFamily: kFontFamily,
                      )),
                  body: const SizedBox.shrink(),
                  onTap: () {
                    if (disableMenu) return;
                    context.read<SearchCubit>().addSearch("", 1, false);

                    if (locationName != screenMovies) {
                      router.pushNamed(screenMovies);
                    }
                  },
                ),
                PaneItem(
                    icon: const Icon(FluentIcons.t_v_monitor_selected),
                    title: const Text('المسلسلات / Series',
                        style: TextStyle(
                          fontFamily: kFontFamily,
                        )),
                    body: Container(),
                    onTap: () {
                      if (disableMenu) return;
                      context.read<SearchCubit>().addSearch("", 2, false);
                      if (locationName != screenSeries) {
                        router.pushNamed(screenSeries);
                      }
                    }),
                PaneItem(
                    icon: const Icon(FluentIcons.streaming),
                    title: const Text('مباشر / Live TV',
                        style: TextStyle(
                          fontFamily: kFontFamily,
                        )),
                    body: Container(),
                    onTap: () {
                      if (disableMenu) return;
                      context.read<SearchCubit>().addSearch("", 3, false);
                      if (locationName != screenLive) {
                        router.pushNamed(screenLive);
                      }
                    }),
              ],
              footerItems: [
                PaneItemSeparator(color: Colors.grey),
                PaneItem(
                    icon: const Icon(FluentIcons.settings),
                    title: const Text('الإعدادات / Settings',
                        style: TextStyle(
                          fontFamily: kFontFamily,
                        )),
                    body: const SizedBox(),
                    onTap: () {
                      if (disableMenu) return;
                      context.read<SearchCubit>().addSearch("", 4, false);
                      showDialog(
                        context: context,
                        builder: (_) => const SettingsPage(),
                      );
                    }),
              ]),
        );
      },
    );
  }
}
