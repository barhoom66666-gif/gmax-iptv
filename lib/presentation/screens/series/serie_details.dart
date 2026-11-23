part of '../screens.dart';

class SerieDetailsPage extends StatefulWidget {
  const SerieDetailsPage(
      {super.key, required this.channelSerie, required this.catyName});

  final ChannelSerie channelSerie;
  final String catyName;

  @override
  State<SerieDetailsPage> createState() => _SerieDetailsPageState();
}

class _SerieDetailsPageState extends State<SerieDetailsPage> {
  // String selectedSeason = "Season 1";

  late Future<SerieDetails?> featureDetails;

  //
  @override
  void initState() {
    featureDetails =
        IpTvApi.getSerieDetails(widget.channelSerie.seriesId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ThumpMovie(
          image: widget.channelSerie.cover,
        ),

        ///Bluer Part
        FutureBuilder<SerieDetails?>(
          future: featureDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CardDetailsLoading();
            } else if (snapshot.hasData) {
              final serieDetail = snapshot.data;

              List<String> listKeysEpisodes =
                  (serieDetail?.episodes ?? {}).keys.toList();
              List<Season> seasons = listKeysEpisodes
                  .map((e) => Season(
                        id: e,
                        name: e,
                        seasonNumber: e,
                      ))
                  .toList();

              // debugPrint("seaons: ${seasons}");

              return Positioned(
                bottom: 0,
                left: 5,
                right: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            widget.channelSerie.name ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: deviceIsWeb(context) ? 35 : 32,
                            height: deviceIsWeb(context) ? 35 : 32,
                            child: BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, state) {
                                final isLiked = state.series.any((movie) =>
                                    movie.seriesId ==
                                    widget.channelSerie.seriesId);
                                return Button(
                                  onPressed: () {
                                    context.read<FavoritesCubit>().addSerie(
                                        widget.channelSerie,
                                        isAdd: !isLiked);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        ButtonState.all(Colors.transparent),
                                  ),
                                  child: Icon(
                                    isLiked
                                        ? FontAwesomeIcons.solidHeart
                                        : FontAwesomeIcons.heart,
                                    color: Colors.white,
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
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 4),
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
                                      Container(
                                        width: getSize(context).width * .15,
                                        height: 33,
                                        decoration: BoxDecoration(
                                          color: FluentTheme.of(context)
                                              .accentColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: ComboBox<String>(
                                          // value: selectedSeason,
                                          placeholder: Text(
                                            'Season ${seasons.length}',
                                            style: TextStyle(
                                              fontSize: deviceIsWeb(context)
                                                  ? 11
                                                  : 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize:
                                                deviceIsWeb(context) ? 11 : 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          items: [
                                            for (int i = 0;
                                                i < seasons.length;
                                                i++)
                                              ComboBoxItem(
                                                value: seasons[i].id ?? "${i + 1}",
                                                child: Text("Season ${seasons[i].id ?? (i + 1)}"),
                                              )
                                          ],
                                          onChanged: (season) {
                                            if (season != null &&
                                                serieDetail?.episodes != null) {
                                              router.pushNamed(
                                                screenSerieSeasons,
                                                queryParameters: {
                                                  "season": season,
                                                  'image': widget
                                                      .channelSerie.cover
                                                      .toString(),
                                                },
                                                extra: serieDetail!
                                                    .episodes![season],
                                              );
                                            } else {
                                              debugPrint("No Episodes found");
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (serieDetail?.info != null &&
                                          serieDetail!.info!.youtubeTrailer !=
                                              null &&
                                          serieDetail.info!.youtubeTrailer
                                              .toString()
                                              .isNotEmpty)
                                        CardButtonTrailer(
                                          onTap: () {
                                            context.pushNamed(
                                              screenYoutube,
                                              extra: serieDetail
                                                  .info!.youtubeTrailer
                                                  .toString(),
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
                                          child: SingleChildScrollView(
                                            child: Text(
                                              serieDetail?.info?.plot ?? widget.channelSerie.plot ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Text(
                                              "${widget.catyName} - ${widget.channelSerie.releaseDate ?? ""} - ${seasons.length} Seasons - ",
                                              style: TextStyle(
                                                color: Colors.grey[40],
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GFRating(
                                              value: double.tryParse(widget
                                                      .channelSerie
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
                                valueKey: ValueKey("movies-details"),
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
            return const SizedBox();
          },
        ),

        ///GO BACK
        const BackButtonX(),
      ],
    );
  }
}
