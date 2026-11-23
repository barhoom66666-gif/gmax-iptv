part of 'helpers.dart';

Size getSize(BuildContext context) => MediaQuery.of(context).size;

bool deviceIsWeb(BuildContext context) => UniversalPlatform.isDesktopOrWeb;

initialBlocs(BuildContext context) {
  context.read<SettingsCubit>().disableMenu(false);
  context.read<FavoritesCubit>().initialData();
  context.read<WatchingCubit>().initialData();
  context.read<CategoriesCubit>().initialCategories();
  context.read<RandomMovieBloc>().add(GetRandomMovie());
}

showLoginDialog(BuildContext context) async {
  await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(
        'Authenticating User',
        style: styleTitle,
      ),
      content: Text(
        "Please wait while we securely authenticate your login credentials. This may take a few moments depending on the strength of your connection and the verification process.\nPlease do not close this window or navigate away from this page.\nThank you for your patience.",
        style: styleBody,
      ),
      actions: [
        Button(
          child: const Text('close'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Future<void> changeDeviceOrientationLandscape() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

Future<void> changeDeviceOrientBack() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

Future<void> showInAppReview() async {
  final InAppReview inAppReview = InAppReview.instance;

  inAppReview.openStoreListing(appStoreId: kAppId, microsoftStoreId: kAppId);
}

Future<void> shareApp() async {
  await Share.share(
    'Alzaabi TV — النسخة الذهبية الخاصة',
  );
}

Future<String?> showDialogUpdateData(
    BuildContext context, String title, String body) async {
  return await showDialog<String>(
    context: context,
    builder: (_) => ContentDialog(
      title: Text(
        title,
        style: styleTitle,
      ),
      content: Text(
        body,
        style: styleBody,
      ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        Button(
          child: const Text('Update'),
          onPressed: () {
            Navigator.pop(context, 'true');
          },
        ),
      ],
    ),
  );
}

Future<void> goFullScreen(bool value) async {
  if (UniversalPlatform.isWeb) {
    if (value) {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive,
        overlays: [],
      );
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ]);
    }
  } else {
    if (UniversalPlatform.isWindows ||
        UniversalPlatform.isLinux ||
        UniversalPlatform.isMacOS) {
      await windowManager.setFullScreen(value);
      Size size = await windowManager.getSize();
      await windowManager.setSize(Size(size.width + 1, size.height + 1));
    } else {
      if (value) {
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersive,
          overlays: [],
        );
      } else {
        //MOBILE
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      }
    }
  }
}

///SQL
String? sanitizeString(dynamic value) {
  if (value == null) return null;
  final s = value.toString().trim();
  if (s.isEmpty || s.toLowerCase() == 'null') {
    return null;
  }
  return s;
}

bool isValidUrl(String url) {
  // Regular expression for a simple URL validation
  RegExp urlRegExp = RegExp(r'^(https?|ftp):\/\/[^\s\/$.?#].[^\s]*$',
      caseSensitive: false, multiLine: false);

  return urlRegExp.hasMatch(url);
}
