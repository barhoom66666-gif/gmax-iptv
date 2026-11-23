part of '../screens.dart';

class MovieDetailsPage extends StatefulWidget {
  final ChannelMovie channelMovie;
  final String channelName;

  const MovieDetailsPage(
      {super.key, required this.channelMovie, required this.channelName});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<MovieDetail?> featureDetails;

  @override
  void initState() {
    featureDetails =
        IpTvApi.getMovieDetails(widget.channelMovie.streamId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ThumpMovie(
          image: widget.channelMovie.streamIcon,
        ),

        ///Blue Part
        FutureBuilder<MovieDetail?>(
          future: featureDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CardDetailsLoading();
            } else {
              final movieDetail = snapshot.data;
              final ext = movieDetail?.movieData?.containerExtension ??
                  widget.channelMovie.containerExtension ??
                  "mp4";
              final plotText = movieDetail?.info?.plot ??
                  widget.channelMovie.plot ??
                  "";
              final releaseText = movieDetail?.info?.releasedate ??
                  widget.channelMovie.releaseDate ??
                  "";
              final durationText = getDurationMovie(movieDetail?.info?.duration);
              final trailerId = movieDetail?.info?.youtubeTrailer ??
                  widget.channelMovie.youtubeTrailer ??
                  "";

              return Positioned(
                bottom: 0,
                right: 5,
                left: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.channelMovie.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: deviceIsWeb(context) ? 35 : 30,
                            height: deviceIsWeb(context) ? 35 : 30,
                            child: BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, state) {
                                final isLiked = state.movies
                                    .where((movie) =>
                                        movie.streamId ==
                                        widget.channelMovie.streamId)
                                    .isNotEmpty;

                                return Button(
                                  onPressed: () {
                                    context.read<FavoritesCubit>().addMovie(
                                        widget.channelMovie,
                                        isAdd: !isLiked);
                                  },
                                  style: ButtonStyle(
                                    padding: ButtonState.all(EdgeInsets.zero),
                                    backgroundColor:
                                        ButtonState.all(Colors.transparent),
                                  ),
                                  child: Icon(
                                    isLiked
                                        ? FontAwesomeIcons.solidHeart
                                        : FontAwesomeIcons.heart,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getSize(context).width,
                      child: Divider(
                        style: DividerThemeData(
                          decoration: BoxDecoration(
                              color: Colors.grey[120].withOpacity(.5)),
                        ),
                      ),
                    ),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
                        child: Container(
                          width: getSize(context).width,
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: getSize(context).width * .15,
                                        height: deviceIsWeb(context) ? 35 : 30,
                                        child: BlocBuilder<AuthBloc, AuthState>(
                                          builder: (context, state) {
                                            final userAuth =
                                                state is AuthSuccess
                                                    ? state.user
                                                    : null;

                                            return CardWatchNow(
                                              label: "Watch",
                                              onTap: () {
                                                final hasDirect = (widget.channelMovie.directSource ?? "").startsWith("http");
                                                final link = hasDirect
                                                    ? widget.channelMovie.directSource!
                                                    : "${userAuth!.domain}/movie/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${widget.channelMovie.streamId}.$ext";
                                                router.pushNamed(
                                                  playerVideo,
                                                  extra: VideoModel(
                                                    cover: widget.channelMovie
                                                        .streamIcon,
                                                    streamId: widget
                                                            .channelMovie
                                                            .streamId ??
                                                        "",
                                                    url: link,
                                                    title: widget.channelMovie
                                                            .name ??
                                                        "",
                                                    isFullScreen: true,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (trailerId.toString().isNotEmpty)
                                        CardButtonTrailer(
                                          onTap: () {
                                            context.pushNamed(
                                              screenYoutube,
                                              extra: trailerId.toString(),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxHeight: 120),
                                          child: Text(
                                            plotText,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Text(
                                              "${widget.channelName} - $releaseText - $durationText - ",
                                              style: TextStyle(
                                                color: Colors.grey[40],
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GFRating(
                                              value: double.tryParse(widget
                                                      .channelMovie
                                                      .rating5based ??
                                                  "0") ?? 0.0,
                                              size: 11,
                                              color: Colors.white,
                                              borderColor: Colors.grey[60],
                                              onChanged: (value) {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const BannerWidget(
                                adSize: AdSize.banner,
                                valueKey: ValueKey("details"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),

        ///GO BACK
        const BackButtonX(),
      ],
    );
  }
}
