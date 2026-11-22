part of '../screens.dart';

class YoutubeTrailerPage extends StatefulWidget {
  const YoutubeTrailerPage({super.key, required this.trailerId});
  final String trailerId;

  @override
  State<YoutubeTrailerPage> createState() => _YoutubeTrailerPageState();
}

class _YoutubeTrailerPageState extends State<YoutubeTrailerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.trailerId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Stack(
        children: [
          SizedBox(
            width: getSize(context).width,
            height: getSize(context).height,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              aspectRatio: 16 / 9,
            ),
          ),

          ///GO BACK
          const Padding(
            padding: EdgeInsets.all(0),
            child: BackButtonX(),
          ),
        ],
      ),
    );
  }
}
