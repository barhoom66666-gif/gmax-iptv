part of '../screens.dart';

class SeasonPage extends StatefulWidget {
  final List<Episode?> episodes;
  final String season;
  final String image;

  const SeasonPage({
    super.key,
    required this.episodes,
    required this.season,
    required this.image,
  });

  @override
  State<SeasonPage> createState() => _SeasonPageState();
}

class _SeasonPageState extends State<SeasonPage> {
  int selectedEpisode = 0;

  VideoController? _controller;
  Player player = Player();

  _init() async {
    final state = context.read<AuthBloc>().state;

    if (state is AuthSuccess) {
      final userAuth = state.user;

      final videos = widget.episodes
          .map((e) => Media((e?.directSource ?? "").startsWith("http")
              ? e!.directSource!
              : "${userAuth.domain}/series/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${e!.id}.${e.containerExtension}"))
          .toList();

      final playable = Playlist(
        videos,
        index: 0,
      );
      await player.open(playable);
      _controller = VideoController(player);
      setState(() {});
    }
  }

  @override
  void initState() {
    //loadInterstitialAd();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  @override
  void dispose() async {
    player.stop();
    super.dispose();
    await player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///Background
        ThumpMovie(image: widget.image),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: SizedBox(
            width: getSize(context).width,
            height: getSize(context).height,
          ),
        ),
        Container(
          width: getSize(context).width,
          height: getSize(context).height,
          color: Colors.black.withOpacity(.8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: getSize(context).width,
                        height: getSize(context).height * .8,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: Stack(
                          children: [
                            ///Player
                            _controller == null
                                ? const SizedBox()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: video.Video(
                                      controller: _controller!,
                                      wakelock: true,
                                      onEnterFullscreen: () async {
                                        goFullScreen(true);
                                        debugPrint("onEnterFullscreen");
                                      },
                                      onExitFullscreen: () async {
                                        debugPrint("onExitFullscreen");
                                        goFullScreen(false);
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    BannerWidget(
                      adSize: AdSize.fullBanner,
                      valueKey: ValueKey("serie-seasons-${widget.season}"),
                    ),
                  ],
                ),
              ),

              ///Episodes
              Container(
                width: deviceIsWeb(context) ? 300 : 200,
                color: Colors.black.withOpacity(.3),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (_, i) {
                    final model = widget.episodes[i];

                    if (model == null) {
                      return const Text('No Episode');
                    }

                    return CardEpisode(
                      model: model,
                      isSelected: selectedEpisode == i,
                      onTap: () async {
                        if (selectedEpisode == i) {
                          debugPrint("same episode idiot");
                          return false;
                        }
                        selectedEpisode = i;
                        player.jump(i);
                        setState(() {});
                      },
                    );
                  },
                  separatorBuilder: (_, i) => const SizedBox(height: 10),
                  itemCount: widget.episodes.length,
                ),
              ),
            ],
          ),
        ),

        ///GO BACK
        const BackButtonX(),
      ],
    );
  }
}
