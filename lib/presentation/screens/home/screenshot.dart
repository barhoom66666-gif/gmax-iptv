part of '../screens.dart';

class ScreenShot extends StatefulWidget {
  const ScreenShot({super.key});

  @override
  State<ScreenShot> createState() => _ScreenShotState();
}

class _ScreenShotState extends State<ScreenShot> {
  goScreen(String screen) {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      debugPrint("GO WELCOME");
      router.pushNamed('screens');
    });
  }

  @override
  void initState() {
    goScreen("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
