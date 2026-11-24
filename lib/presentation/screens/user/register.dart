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
  final GlobalKey<CardXTREAMState> _xtreamKey = GlobalKey<CardXTREAMState>();
  final GlobalKey<CardM3UState> _m3uKey = GlobalKey<CardM3UState>();

  @override
  void initState() {
    super.initState();
    tabController = material.TabController(
      length: lengthTab,
      vsync: this,
      initialIndex: 1, // Open on XTREME tab by default
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _startAddNewCode() {
    tabController.animateTo(1);
    _xtreamKey.currentState?.clearFieldsForNewCode();
    _m3uKey.currentState?.clearFieldsForNewCode();
  }

  @override
  Widget build(BuildContext context) {
    final theme = material.Theme.of(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return CardCHeck(
          setting: state.setting,
          child: Container(
            decoration: kDecorBackground,
            width: getSize(context).width,
            child: Row(
              children: [
                SizedBox(
                  width:
                      getSize(context).width * (deviceIsWeb(context) ? .42 : .35),
                  child: const IntroImageAnimated(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // "+ Add New Code" button (clears fields to add a new code)
                            FilledButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    ButtonState.all(const Color(0xFFD5B055)),
                              ),
                              onPressed: _startAddNewCode,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    FluentIcons.add,
                                    size: 12,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "إضافة كود جديد +",
                                    style: styleBody.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quick 1-tap button for the new 24h Trial (151ea3ffc3b2 on cf.uscahd.xyz)
                            FilledButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(AuthRegister(
                                      "151ea3ffc3b2",
                                      "fc9bcff236",
                                      "http://cf.uscahd.xyz",
                                      "World 8K (151ea3ffc3b2)",
                                      typeLogin: "XTREME",
                                    ));
                              },
                              child: Text(
                                "▶ تشغيل كود التجربة الجديد (24h)",
                                style: styleBody.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: getSize(context).width,
                          child: Row(
                            children: [
                              SizedBox(
                                width: deviceIsWeb(context) ? 110 : 85,
                                child: Text(
                                  'نوع القائمة',
                                  style: styleBody,
                                ),
                              ),
                              Expanded(
                                child: GFSegmentTabs(
                                  height: 26,
                                  tabController: tabController,
                                  tabBarColor: theme.scaffoldBackgroundColor,
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  indicator: BoxDecoration(
                                    color: kColorPrimary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: Border.all(
                                    color: kColorPrimary,
                                    width: .6,
                                  ),
                                  length: lengthTab,
                                  indicatorPadding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  tabs: [
                                    "رابط M3U",
                                    "كود XTREME",
                                    "الأكواد المحفوظة"
                                  ]
                                      .map(
                                        (text) => Text(
                                          text,
                                          style: styleBody.copyWith(
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: getSize(context).width,
                          height: getSize(context).height * 0.72,
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
                                  CardM3U(key: _m3uKey, isLoading: isLoading),
                                  CardXTREAM(
                                      key: _xtreamKey, isLoading: isLoading),
                                  CardMyPlaylists(
                                    isLoading: isLoading,
                                    onAddNewTap: _startAddNewCode,
                                  ),
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
