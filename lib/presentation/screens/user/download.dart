part of '../screens.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  bool showWarning = true;

  @override
  void initState() {
    context.read<DownloadBloc>().add(DownloadAllCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kDecorBackground,
      padding: const EdgeInsets.all(20),
      child: BlocConsumer<DownloadBloc, DownloadState>(
        listener: (context, state) {
          if (state is DownloadFinish) {
            context.read<SettingsCubit>().disableMenu(false);

            Future.delayed(const Duration(seconds: 2)).then((value) {
              debugPrint("Go Home");
              router.goNamed(screenHome);
            });
          }
        },
        builder: (context, state) {
          final int total = state is DownloadLoading ? state.total ?? 0 : 0;
          final int remain = state is DownloadLoading ? state.progress ?? 0 : 0;

          final String status = state is DownloadLoading ? state.label : "";

          return Column(
            children: [
              ///Warning Download
              if (showWarning)
                InfoBar(
                  title: Text(
                    'Downloading Data',
                    style: styleTitle.copyWith(
                      fontSize: deviceIsWeb(context) ? 14 : 14,
                    ),
                  ),
                  content: Text(
                    "Our app is downloading your requested data.\nThis may take several minutes to complete depending on the size of the data and your internet connection speed.\nPlease do not close the app or navigate away from this page until the download is complete.\nWe appreciate your patience and will notify you when the download is finished.",
                    style: styleBody.copyWith(
                      fontSize: deviceIsWeb(context) ? 12 : 12,
                    ),
                  ),
                  severity: InfoBarSeverity.info,
                  isLong: true,
                  onClose: () {
                    setState(() {
                      showWarning = false;
                    });
                  },
                ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      status,
                      style: styleTitle,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'This operation can take a few minutes please wait...',
                      style: styleBody.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[60],
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                    size: deviceIsWeb(context) ? 20 : 18,
                    color: Colors.grey[90],
                  ),
                  const SizedBox(width: 10),
                  if (total != 0 && remain != 0)
                    Text(
                      'Downloading $remain / $total',
                      style: styleTitle.copyWith(
                        fontSize: deviceIsWeb(context) ? 13 : 13,
                        color: Colors.grey[90],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
