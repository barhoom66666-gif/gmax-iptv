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
                                  title: "App version",
                                  label: kAppVersion,
                                  color: Colors.blue,
                                  body: "Keep your app always up to date",
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
                              'Preferences',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: deviceIsWeb(context) ? 11 : 12,
                              ),
                            ),
                          ),
                          SettingTileButton(
                            color: Colors.green.lightest,
                            label: "Playlist",
                            icon: FluentIcons.cloud_download,
                            isSelected: true,
                            onTap: () {},
                          ),
                          /*  SettingTileButton(
                            color: Colors.purple.lightest,
                            label: "EPG",
                            icon: FluentIcons.context_menu,
                            isSelected: false,
                            onTap: () {},
                          ),
                          SettingTileButton(
                            color: Colors.magenta.light,
                            label: "Video Player",
                            icon: FontAwesomeIcons.circlePlay,
                            isSelected: false,
                            onTap: () {},
                          ),*/

                          ///Playlist actions
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Playlist actions',
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
                                label: "Reload Movies",
                                icon: FluentIcons.cloud_download,
                                isSelected: isLoading,
                                isLoading: isLoading,
                                status: "($progress/$total)",
                                onTap: () async {
                                  await showDialogUpdateData(
                                    context,
                                    "Update Movies",
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
                                label: "Reload Tv Shows",
                                icon: FluentIcons.cloud_download,
                                isSelected: isLoading,
                                isLoading: isLoading,
                                status: "($progress/$total)",
                                onTap: () async {
                                  await showDialogUpdateData(
                                    context,
                                    "Update Tv Shows",
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
                                label: "Reload Live",
                                icon: FluentIcons.cloud_download,
                                isSelected: isLoading,
                                isLoading: isLoading,
                                status: "($progress/$total)",
                                onTap: () async {
                                  await showDialogUpdateData(
                                    context,
                                    "Update Live",
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
                          /* SettingTileButton(
                            color: Colors.yellow.darkest,
                            label: "Hide categories",
                            icon: FluentIcons.collapse_menu,
                            isSelected: false,
                            onTap: () {},
                          ),*/

                          ///Reach us
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Reach us',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: deviceIsWeb(context) ? 11 : 12,
                              ),
                            ),
                          ),
                          SettingTileButton(
                            color: Colors.red.lightest,
                            label: "Contact us",
                            icon: FontAwesomeIcons.envelope,
                            isSelected: false,
                            onTap: () async {
                              await launchUrlString("mailto:$kEmailSupport");
                            },
                          ),
                          SettingTileButton(
                            color: Colors.orange.lighter,
                            label: "Review the app",
                            icon: FontAwesomeIcons.star,
                            isSelected: false,
                            onTap: () async {
                              await launchUrlString(kReviewApp);
                            },
                          ),
                          SettingTileButton(
                            color: Colors.blue.light,
                            label: "Follow us on Twitter",
                            icon: FontAwesomeIcons.twitter,
                            isSelected: false,
                            onTap: () async {
                              await launchUrlString(kTwitter);
                            },
                          ),
                          SettingTileButton(
                            color: Colors.purple.dark,
                            label: "Follow us on Instagram",
                            icon: FontAwesomeIcons.instagram,
                            isSelected: false,
                            onTap: () async {
                              await launchUrlString(kInstagram);
                            },
                          ),
                          SettingTileButton(
                            color: Colors.blue.darker,
                            label: "Follow us on Facebook",
                            icon: FontAwesomeIcons.facebookF,
                            isSelected: false,
                            onTap: () async {
                              await launchUrlString(kFacebook);
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
