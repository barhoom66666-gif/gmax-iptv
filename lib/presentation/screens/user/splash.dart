part of '../screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  goScreen(String screen, bool isGo) {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      debugPrint("go $screen");
      router.goNamed(screen);
    });
  }

  @override
  void initState() {
    final isDesktop = UniversalPlatform.isDesktop;
    if (!isDesktop) {
      try {
        FlutterNativeSplash.remove();
      } catch (_) {}
    }
    context.read<SettingsCubit>().getSettingsCode();

    super.initState();
    debugPrint("YOU ARE IN SPLASH SCREEN NOW");
    Future.delayed(const Duration(seconds: 2)).then((value) {
      context.read<AuthBloc>().add(AuthGetUser());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, stateSet) {
        // debugPrint("SPLASH: ${stateSet.setting}");
        if (stateSet.setting != 'loading') {
          debugPrint("Check Auth now");
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            context.read<SettingsCubit>().disableMenu(false);
            context.read<CategoriesCubit>().initialCategories();

            goScreen(screenHome, true);
          } else if (state is AuthFailed) {
            goScreen(screenRegister, false);
          }
        },
        child: const CardLoadingSplash(),
      ),
    );
  }
}

class CardLoadingSplash extends StatelessWidget {
  const CardLoadingSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kDecorBackground,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            kIconSplash,
            width: deviceIsWeb(context) ? 180 : 140,
            height: deviceIsWeb(context) ? 180 : 140,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
