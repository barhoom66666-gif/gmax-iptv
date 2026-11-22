part of '../screens.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with material.TickerProviderStateMixin {
  late material.TabController tabController;

  final int lengthTab = 3;

  @override
  void initState() {
    super.initState();
    tabController = material.TabController(
      length: lengthTab,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = material.Theme.of(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        debugPrint("SETTING: ${state.setting}");
        return CardCHeck(
          setting: state.setting,
          child: Container(
            decoration: kDecorBackground,
            width: getSize(context).width,
            child: Row(
              children: [
                SizedBox(
                  width:
                      getSize(context).width * (deviceIsWeb(context) ? .5 : .4),
                  child: const IntroImageAnimated(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'New Playlist'.toUpperCase(),
                              style: styleTitle,
                            ),
                            FilledButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(AuthRegister(
                                      "demo",
                                      "demo",
                                      "https://demo.gmax.iptv",
                                      "GMAX Demo",
                                      typeLogin: "XTREME",
                                    ));
                              },
                              child: Text(
                                "▶ Try Demo Playlist",
                                style: styleBody.copyWith(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: getSize(context).width,
                          child: Row(
                            children: [
                              SizedBox(
                                width: deviceIsWeb(context) ? 130 : 100,
                                child: Text(
                                  'Playlist Type',
                                  style: styleBody,
                                ),
                              ),
                              Expanded(
                                child: GFSegmentTabs(
                                  height: 22,
                                  tabController: tabController,
                                  tabBarColor: theme.scaffoldBackgroundColor,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  indicator: BoxDecoration(
                                    color: Colors.grey[130],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: Border.all(
                                    color: Colors.grey[90],
                                    width: .5,
                                  ),
                                  length: lengthTab,
                                  indicatorPadding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  tabs: ["M3U", "XTREME", "PLAYLISTS"]
                                      .map(
                                        (text) => Text(
                                          text,
                                          style: styleBody.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: getSize(context).width,
                          height: getSize(context).height,
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                router.pushNamed(screenDownload);
                              } else if (state is AuthFailed) {
                                debugPrint("SHOW ERROR MESSAGE");
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;

                              return GFTabBarView(
                                controller: tabController,
                                children: [
                                  CardM3U(isLoading: isLoading),
                                  CardXTREAM(isLoading: isLoading),
                                  CardMyPlaylists(isLoading: isLoading),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CardCHeck extends StatelessWidget {
  const CardCHeck({super.key, required this.child, required this.setting});

  final Widget child;
  final String setting;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
