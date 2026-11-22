import 'package:media_kit_video/media_kit_video.dart';

class VideoModel {
  final String title;
  final String url, streamId;
  final bool isLive;
  final bool isSeries;
  final bool isFullScreen;
  final String? cover;
  final List<VideoEpisode>? episodes;
  final VideoController? controller;

  VideoModel({
    this.cover,
    this.isLive = false,
    required this.title,
    required this.url,
    required this.streamId,
    this.isFullScreen = true,
    this.isSeries = false,
    this.episodes = const [],
    this.controller,
  });
}

class VideoEpisode {
  final String name;
  final String url;

  VideoEpisode({required this.name, required this.url});
}
