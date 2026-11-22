part of 'widgets.dart';

class AppBarMain extends StatelessWidget {
  const AppBarMain({super.key});

  @override
  Widget build(BuildContext context) {
    final contextController = FlyoutController();
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final disableMenu = state.disableMenu;

        if (disableMenu) {
          return const CardLogoApp();
        }

        return Row(
          children: [
            const CardLogoApp(),
            const Spacer(),

            const InputSearchBar(),

            ///Show Offers
            /*    IconButton(
              icon: const Icon(FontAwesomeIcons.fire),
              onPressed: () {},
            ),

            ///Notification
            IconButton(
              icon: const Icon(FontAwesomeIcons.bell),
              onPressed: () {},
            ),
            const SizedBox(width: 5),*/

            ///Account
            FlyoutTarget(
              controller: contextController,
              child: IconButton(
                icon: const Icon(FluentIcons.settings),
                onPressed: () {
                  contextController.showFlyout(
                    barrierColor: Colors.black.withOpacity(0.1),
                    builder: (context) {
                      return FlyoutContent(
                        child: SizedBox(
                          width: 130.0,
                          child: CommandBar(
                            overflowBehavior: CommandBarOverflowBehavior.wrap,
                            primaryItems: [
                              CommandBarButton(
                                icon: const Icon(FluentIcons.access_logo),
                                label: const Text('Settings'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  context
                                      .read<SearchCubit>()
                                      .addSearch("", null, false);
                                  showDialog(
                                    context: context,
                                    builder: (_) => const SettingsPage(),
                                  );
                                },
                              ),
                              CommandBarButton(
                                icon: const Icon(FluentIcons.sign_out),
                                label: const Text('LogOut'),
                                onPressed: () {
                                  context
                                      .read<SettingsCubit>()
                                      .disableMenu(true);
                                  context.read<AuthBloc>().add(AuthLogOut());
                                  Navigator.pop(context);
                                  router.goNamed(screenRegister);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardLogoApp extends StatelessWidget {
  const CardLogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      kIconSplashSvg,
      width: 110,
      fit: BoxFit.cover,
    );
  }
}

class InputSearchBar extends StatelessWidget {
  const InputSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final page = state.page;
        final bool showSearch = state.showSearch;

        debugPrint("show search page: $page $showSearch");

        if ([1, 2, 3].contains(page)) {
          return Row(
            children: [
              if (showSearch)
                Container(
                  width: getSize(context).width * .25,
                  height: 25,
                  constraints: const BoxConstraints(
                    maxWidth: 270,
                  ),
                  child: SizedBox(
                    width: getSize(context).width * .25,
                    height: 28,
                    child: Center(
                      child: TextBox(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        placeholder: 'Search...',
                        onChanged: (String value) {
                          context
                              .read<SearchCubit>()
                              .addSearch(value, null, true);
                        },
                        suffix: IconButton(
                          icon: const Icon(
                            FluentIcons.clear,
                            size: 9,
                          ),
                          onPressed: () {
                            context
                                .read<SearchCubit>()
                                .addSearch("", null, false);
                          },
                        ),
                        style: TextStyle(
                          fontSize: deviceIsWeb(context) ? 10 : 12,
                        ),
                      ),
                    ),
                  ),
                ),
              if (showSearch) const SizedBox(width: 3),
              if (!showSearch)
                IconButton(
                  icon: const Icon(FluentIcons.search),
                  onPressed: () {
                    context.read<SearchCubit>().addSearch(null, null, true);
                  },
                ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class BackButtonX extends StatelessWidget {
  const BackButtonX({super.key, this.onBack});

  final Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topRight,
        child: FilledButton(
          style: ButtonStyle(
            padding: ButtonState.all(const EdgeInsets.all(6)),
          ),
          onPressed: () {
            context.read<SearchCubit>().addSearch("", null, false);
            Navigator.pop(context);

            if (onBack != null) {
              onBack!();
            }
          },
          child: const Icon(
            FluentIcons.chrome_close,
            size: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CardNoImage extends StatelessWidget {
  const CardNoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: kColorCardDark,
      child: Center(
        child: SvgPicture.asset(
          kIconSplashSvg,
          //color: kColorCardLight,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}

class CardDetailsLoading extends StatelessWidget {
  const CardDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: LoadingAnimationWidget.inkDrop(
          color: Colors.white,
          size: 40,
        )),
        const SizedBox(height: 20),
        Text(
          'Loading...',
          style: styleBody,
        ),
      ],
    );
  }
}
