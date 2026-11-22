part of '../screens.dart';

class MoviePlayerPage extends StatefulWidget {
  final VideoModel videoModel;

  const MoviePlayerPage({
    super.key,
    required this.videoModel,
  });

  @override
  State<MoviePlayerPage> createState() => _MoviePlayerPageState();
}

class _MoviePlayerPageState extends State<MoviePlayerPage> {
  late VideoModel videoModel;
  late VideoController _controller;
  Player player = Player();

  List<double> aspectRatios = [16 / 9, 4 / 3, 1.85, 1.78, 1.33, 2.39, 1.66];
  int currentAspectRatioIndex = 0;

  _init() async {
    player.open(kIsDebugTest ? Media(kVideoBunny) : Media(videoModel.url));
    _controller = VideoController(player);
  }

  @override
  void initState() {
    goFullScreen(true);
    videoModel = widget.videoModel;
    //  loadInterstitialAd();
    super.initState();
    _init();
  }

  @override
  void dispose() async {
    goFullScreen(false);
    player.stop();
    super.dispose();
    await player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getSize(context).width,
      height: getSize(context).height,
      child: Stack(
        children: [
          ///Player
          MaterialVideoControlsTheme(
            fullscreen: const MaterialVideoControlsThemeData(),
            normal: MaterialVideoControlsThemeData(
              topButtonBar: [
                const Spacer(),
                Button(
                  child: const Icon(FluentIcons.chrome_close),
                  onPressed: () => context.pop(),
                ),
              ],
              bottomButtonBar: [
                const MaterialPositionIndicator(),
                const Spacer(),
              ],
              bottomButtonBarMargin:
                  const EdgeInsets.only(bottom: 40, left: 30, right: 30),
              seekBarMargin:
                  const EdgeInsets.only(bottom: 30, left: 30, right: 30),
            ),
            child: video.Video(
              controller: _controller,
              wakelock: true,
              controls: MaterialVideoControls,
              aspectRatio: aspectRatios[currentAspectRatioIndex],
            ),
          ),
        ],
      ),
    );
  }
}
