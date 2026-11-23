part of '../screens.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final isLargeWidth = getSize(context).width > 1300;
    final isLargeHeight = getSize(context).height > 800;
    //  debugPrint("Height: ${getSize(context).height}");
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: getSize(context).width * (isLargeWidth ? .7 : .9),
            height: getSize(context).height * (isLargeHeight ? .7 : .9),
            constraints: const BoxConstraints(),
            decoration: BoxDecoration(
              color: Colors.grey[200].withOpacity(.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[190],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            height: 135,
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  UniversalPlatform.isDesktopOrWeb ? 15 : 5,
                              horizontal: 10,
                            ),
                            child: Row(
                              children: [
                                /*  CardSettingInfo(
                                  icon: FluentIcons.favorite_star_fill,
                                  title: "Premium",
                                  label: "Upgrade Now",
                                  body: "Not Active",
                                  color: Colors.red,
                                  onTap: () {
                                    setState(() {
                                      indexPage = 0;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),*/
                                CardSettingInfo(
                                  icon: FluentIcons.settings_sync,
                                  title: "إصدار التطبيق / Version",
                                  label: kAppVersion,
                                  color: kColorPrimary,
                                  body: "Alzaabi TV — النسخة الذهبية الخاصة",
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          /* SettingTileButton(
                            color: Colors.blue.lightest,
                            label: "Restore Purchase",
                            icon: FluentIcons.shopping_cart,
                            isSelected: true,
                            onTap: () {
                              setState(() {
                                indexPage = 0;
                              });
                            },
                          ),*/
                          /* SettingTileButton(
                            color: Colors.red.lightest,
                            label: "Membership benefits",
                            icon: FontAwesomeIcons.award,
                            isSelected: false,
                            onTap: () {
                              setState(() {
                                indexPage = 0;
                              });
                            },
                          ),*/

                          ///Appearance
                          /*  const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Appearance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SettingTileButton(
                            color: Colors.orange,
                            label: "Appearance",
                            icon: FluentIcons.light,
                            isSelected: false,
                            onTap: () {
                              setState(() {
                                indexPage = 1;
                              });
                            },
                          ),*/

                          ///Preferences
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              'الاشتراكات / Playlists',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: deviceIsWeb(context) ? 11 : 12,
                              ),
                            ),
                          ),
                          SettingTileButton(
                            color: kColorPrimary,
                            label: "قائمة التشغيل النشطة",
                            icon: FluentIcons.cloud_download,
                            isSelected: true,
                            onTap: () {},
                          ),

                          ///Playlist actions
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              'تحديث المحتوى / Actions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: deviceIsWeb(context) ? 11 : 12,
                              ),
                            ),
                          ),
                          BlocBuilder<DownloadBloc, DownloadState>(
                            builder: (context, state) {
                              final bool isLoading = state is DownloadLoading &&
                                  state.label == "Download Movie";
                              final total = isLoading ? state.total ?? 0 : 0;
                              final progress =
                                  isLoading ? state.progress ?? 0 : 0;

                              return SettingTileButton(
                                color: Colors.teal.light,
                                label: "تحديث الأفلام / Reload Movies",
                                icon: FluentIcons.cloud_download,
                                isSelected: isLoading,
                                isLoading: isLoading,
                                status: "($progress/$total)",
                                onTap: () async {
                                  await showDialogUpdateData(
                                    context,
                                    "تحديث الأفلام",
                                    kUpdateMovies,
                                  ).then((result) {
                                    if (result == "true") {
                                      context.read<DownloadBloc>().add(
                                          DownloadMoviesEvent(forceAll: false));
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          BlocBuilder<DownloadBloc, DownloadState>(
                            builder: (context, state) {
                              final bool isLoading = state is DownloadLoading &&
                                  state.label == "Download Series";
                              final total = isLoading ? state.total ?? 0 : 0;
                              final progress =
                                  isLoading ? state.progress ?? 0 : 0;
                              return SettingTileButton(
                                color: Colors.yellow.darkest,
                                label: "تحديث المسلسلات / Reload Series",
                                icon: FluentIcons.cloud_download,
                                isSelected: isLoading,
                                isLoading: isLoading,
                                status: "($progress/$total)",
                                onTap: () async {
                                  await showDialogUpdateData(
                                    context,
                                    "تحديث المسلسلات",
                                    kUpdateSeries,
                                  ).then((result) {
                                    if (result == "true") {
                                      context
                                          .read<DownloadBloc>()
                                          .add(DownloadSeriesEvent());
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          BlocBuilder<DownloadBloc, DownloadState>(
                            builder: (context, state) {
                              final bool isLoading = state is DownloadLoading &&
                                  state.label == "Download live";
                              final total = isLoading ? state.total ?? 0 : 0;
                              final progress =
                                  isLoading ? state.progress ?? 0 : 0;
                              return SettingTileButton(
                                color: Colors.purple.light,
                                label: "تحديث البث المباشر / Reload Live",
                                icon: FluentIcons.cloud_download,
                                isSelected: isLoading,
                                isLoading: isLoading,
                                status: "($progress/$total)",
                                onTap: () async {
                                  await showDialogUpdateData(
                                    context,
                                    "تحديث البث المباشر",
                                    kUpdateLive,
                                  ).then((result) {
                                    if (result == "true") {
                                      context.read<DownloadBloc>().add(
                                          DownloadLivesEvent(forceAll: false));
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: [
                    //  const MemberShip(),
                    //   const AppearanceSetting(),
                    const PlayListSetting(),
                  ][indexPage],
                ),
              ],
            ),
          ),

          ///GO BACK
          Positioned(
            top: 5,
            right: 10,
            child: BackButtonX(
              onBack: () {
                context.read<CategoriesCubit>().initialCategories();
              },
            ),
          ),
        ],
      ),
    );
  }
}
