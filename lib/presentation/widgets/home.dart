part of 'widgets.dart';

class CardRandomMovie extends StatelessWidget {
  const CardRandomMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomMovieBloc, RandomMovieState>(
      builder: (context, state) {
        if (state is RandomMovieSuccess) {
          final movie = state.movie;

          // debugPrint("random type: ${movie}");

          return Container(
            width: getSize(context).width,
            height: getSize(context).height * .4,
            constraints: BoxConstraints(
              maxHeight: UniversalPlatform.isDesktopOrWeb ? 450 : 300,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: movie.streamIcon ?? "",
                    width: getSize(context).width,
                    height: getSize(context).height,
                    fit: BoxFit.cover,
                    errorWidget: (_, i, e) {
                      return const CardNoImage();
                    },
                    placeholder: (_, i) {
                      return const CardNoImage();
                    },
                  ),

                  ///Gradient
                  Container(
                    width: getSize(context).width,
                    height: getSize(context).height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          FluentTheme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(.99),
                          kColorBack.withOpacity(.3),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TYPE
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[140],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Movie',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: kFontFamily,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        //Title
                        Text(
                          movie.name ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: kFontFamily,
                          ),
                        ),
                        const SizedBox(height: 5),
                        //Info
                        Row(
                          children: [
                            Text(
                              '${state.channelName} - ',
                              style: TextStyle(
                                color: Colors.grey[70],
                                fontSize: 12,
                                fontFamily: kFontFamily,
                              ),
                            ),
                            GFRating(
                              value: double.parse(movie.rating5based ?? "0"),
                              size: 11,
                              color: Colors.white,
                              borderColor: Colors.grey[60],
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CardWatchNow(
                              label: "Watch Now",
                              onTap: () {
                                router
                                    .pushNamed(
                                  screenMoviesDetails,
                                  queryParameters: {
                                    "channel_name": state.channelName,
                                  },
                                  extra: movie,
                                )
                                    .then((value) {
                                  loadInterstitialAd();
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, state) {
                                final isLiked = state.movies.where((value) {
                                  return value.streamId == movie.streamId;
                                }).isNotEmpty;

                                //  final isLiked = likes.isNotEmpty;

                                return IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? FontAwesomeIcons.solidHeart
                                        : FontAwesomeIcons.heart,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<FavoritesCubit>()
                                        .addMovie(movie, isAdd: !isLiked);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class CardWatchNow extends StatelessWidget {
  const CardWatchNow({super.key, required this.label, required this.onTap});

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FluentIcons.play_solid,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: kFontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

class CardOurOfferItem extends StatelessWidget {
  const CardOurOfferItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getSize(context).width,
      decoration: BoxDecoration(
        color: kColorHintGrey.withOpacity(.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 120,
              ),
              child: Image(
                image: const AssetImage(kImageIntro),
                width: double.infinity,
                height: getSize(context).height * .14,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 10,
            ),
            child: Text(
              '1 month only 5\$',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: kFontFamily,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Let your kids watch cartoun and movies anytime with our fast servers',
              style: TextStyle(
                color: Colors.grey[70],
                fontSize: 11.5,
                fontFamily: kFontFamily,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  child: const Text(
                    'Not Now',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.white,
                      fontFamily: kFontFamily,
                    ),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                FilledButton(
                  child: const Text(
                    'Buy now',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.white,
                      fontFamily: kFontFamily,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardHomeRecentChannels extends StatelessWidget {
  const CardHomeRecentChannels({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final lives = state.lives;

        if (lives.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 5),
                Text(
                  'Channels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: kFontFamily,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height:
                  getSize(context).height * (deviceIsWeb(context) ? .16 : .18),
              width: getSize(context).width,
              constraints: const BoxConstraints(
                maxHeight: 90,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return CardHomeFavChannelsItem(model: lives[i]);
                },
                separatorBuilder: (_, i) {
                  return const SizedBox(width: 10);
                },
                itemCount: lives.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardHomeFavChannelsItem extends StatelessWidget {
  const CardHomeFavChannelsItem({super.key, this.model});

  final ChannelLive? model;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userAuth = state is AuthSuccess ? state.user : null;
        return HoverButton(onPressed: () {
          //TODO: open live
          final hasDirect = (model?.directSource ?? "").startsWith("http");
          final link = hasDirect
              ? model!.directSource!
              : "${userAuth!.domain}/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${model!.streamId}";

          router
              .pushNamed(
            livePlayer,
            extra: VideoModel(
              url: link,
              streamId: model!.streamId ?? "",
              title: model!.name ?? "",
              isFullScreen: true,
              isLive: true,
            ),
          )
              .then((value) {
            loadInterstitialAd();
          });
        }, builder: (context, state) {
          final isFocussed = state.isHovering || state.isFocused;
          return Container(
            width: getSize(context).width * (isFocussed ? .181 : .18),
            constraints: BoxConstraints(
              maxWidth: isFocussed ? 190.5 : 190,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isFocussed
                              ? kColorPrimary.withOpacity(.4)
                              : Colors.grey[140],
                          width: .5,
                        )),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: model!.streamIcon ?? "",
                            width: getSize(context).width,
                            height: getSize(context).height,
                            fit: BoxFit.contain,
                            placeholder: (_, i) {
                              return const CardNoImage();
                            },
                            errorWidget: (_, ni, e) {
                              return const CardNoImage();
                            },
                          ),
                        ),
                        BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, state) {
                            final isLiked = state.lives
                                .where((element) =>
                                    element.streamId == model!.streamId)
                                .toList()
                                .isNotEmpty;

                            return IconButton(
                              icon: Icon(
                                isLiked
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                context
                                    .read<FavoritesCubit>()
                                    .addLive(model!, isAdd: !isLiked);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  model!.name ?? "",
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: kFontFamily,
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

class CardFavMovies extends StatelessWidget {
  const CardFavMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final movies = state.movies;

        if (movies.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Row(
              children: [
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 5),
                Text(
                  'Movies',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: kFontFamily,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: getSize(context).width,
              height:
                  getSize(context).height * (deviceIsWeb(context) ? .27 : .33),
              constraints: const BoxConstraints(maxHeight: 185),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return CardMovieItem(
                    name: movies[i].name ?? "",
                    image: movies[i].streamIcon ?? "",
                    onTap: () {
                      router
                          .pushNamed(
                        screenMoviesDetails,
                        queryParameters: {
                          "channel_name": "",
                        },
                        extra: movies[i],
                      )
                          .then((value) {
                        loadInterstitialAd();
                      });
                    },
                  );
                },
                separatorBuilder: (_, i) {
                  return SizedBox(width: deviceIsWeb(context) ? 15 : 10);
                },
                itemCount: movies.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardFavTvSHows extends StatelessWidget {
  const CardFavTvSHows({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final tvshows = state.series;

        if (tvshows.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Row(
              children: [
                Icon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 5),
                Text(
                  'Tv Shows',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: getSize(context).width,
              height:
                  getSize(context).height * (deviceIsWeb(context) ? .27 : .33),
              constraints: const BoxConstraints(maxHeight: 185),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return CardMovieItem(
                    name: tvshows[i].name ?? "",
                    image: tvshows[i].cover ?? "",
                    onTap: () {
                      router.pushNamed(screenSerieDetails,
                          extra: tvshows[i],
                          queryParameters: {
                            "channel_name": "",
                          }).then((value) {
                        loadInterstitialAd();
                      });
                    },
                  );
                },
                separatorBuilder: (_, i) {
                  return SizedBox(width: deviceIsWeb(context) ? 15 : 10);
                },
                itemCount: tvshows.length,
              ),
            ),
            const SizedBox(height: 5),
            const BannerWidget(
              adSize: AdSize.banner,
              valueKey: ValueKey("fav-series-home"),
            ),
          ],
        );
      },
    );
  }
}

class CardRecentWatching extends StatelessWidget {
  final WatchingModel model;

  const CardRecentWatching({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: () {
        router
            .pushNamed(
          playerVideo,
          extra: VideoModel(
            cover: model.image,
            streamId: model.streamId,
            url: model.stream,
            title: model.title,
            isFullScreen: true,
          ),
        )
            .then((value) {
          loadInterstitialAd();
        });
      },
      builder: (context, state) {
        final isHovered = state.isFocused || state.isHovering;

        return Container(
          constraints: const BoxConstraints(maxWidth: 280),
          width: getSize(context).width * .28,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: model.image ?? "",
                        width: getSize(context).width,
                        height: getSize(context).height,
                        fit: BoxFit.cover,
                        errorWidget: (_, i, e) {
                          return const CardNoImage();
                        },
                        placeholder: (_, e) {
                          return const CardNoImage();
                        },
                      ),
                      Container(
                          color: isHovered
                              ? kColorPrimaryDark.withOpacity(.3)
                              : Colors.grey.withOpacity(.5)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FluentIcons.play_solid,
                            size: deviceIsWeb(context) ? 35 : 28,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              model.title,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 2,
                  width: getSize(context).width,
                  color: Colors.grey[90],
                  child: Row(
                    children: [
                      Expanded(
                          flex: (model.sliderValue * 10).round(),
                          child: Container(
                            color: kColorPrimary,
                          )),
                      Expanded(
                          flex: (model.totalDuration * 10).round(),
                          child: const SizedBox()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CardContinueWatching extends StatelessWidget {
  const CardContinueWatching({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchingCubit, WatchingState>(
      builder: (context, state) {
        final list = state.videos;
        if (list.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Continue Watching',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: getSize(context).width,
              height: getSize(context).height * .20,
              constraints: const BoxConstraints(
                maxHeight: 150,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return CardRecentWatching(
                    model: list[i],
                  );
                },
                separatorBuilder: (_, i) {
                  return const SizedBox(width: 10);
                },
                itemCount: list.length,
              ),
            )
          ],
        );
      },
    );
  }
}
