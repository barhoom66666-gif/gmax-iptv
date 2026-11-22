part of '../screens.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final channels = state.movies;
        debugPrint("Caty Movies: ${channels.length}");
        return BlocBuilder<SearchCubit, SearchState>(
          builder: (context, stateSearch) {
            final searchKey = stateSearch.searchKey;
            List<CategoryModel> searchChannels = channels
                .where((element) =>
                    element.categoryName!.toLowerCase().contains(searchKey))
                .toList();

            return ListView.separated(
              itemCount:
                  searchKey.isEmpty ? channels.length : searchChannels.length,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              itemBuilder: (_, i) {
                final modelChannel =
                    searchKey.isEmpty ? channels[i] : searchChannels[i];
                return FutureBuilder<List<ChannelMovie>>(
                    future: MoviesLocale.getMoviesByCaty(
                      modelChannel.categoryId.toString(),
                      page: 1,
                      pageSize: 10,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      final movies = snapshot.data;

                      return Column(
                        children: [
                          CardChannelTile(
                            label: modelChannel.categoryName ?? "",
                            onTap: () {
                              context
                                  .read<SearchCubit>()
                                  .addSearch("", null, true);
                              router.pushNamed(screenMoreMovies,
                                  queryParameters: {
                                    "id": modelChannel.categoryId!,
                                    "name": modelChannel.categoryName!,
                                  }).then((value) {
                                loadInterstitialAd();
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: getSize(context).width,
                            height: getSize(context).height *
                                (deviceIsWeb(context) ? .27 : .33),
                            constraints: const BoxConstraints(maxHeight: 185),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, i) {
                                final model = movies[i];

                                return CardMovieItem(
                                  image: model.streamIcon ?? "",
                                  name: model.name ?? "",
                                  rate: double.parse(model.rating5based ?? "0"),
                                  onTap: () {
                                    router
                                        .pushNamed(
                                      screenMoviesDetails,
                                      queryParameters: {
                                        "channel_name": modelChannel
                                            .categoryName
                                            .toString(),
                                      },
                                      extra: model,
                                    )
                                        .then((value) {
                                      loadInterstitialAd();
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (_, i) {
                                return SizedBox(
                                  width: deviceIsWeb(context) ? 15 : 10,
                                );
                              },
                              itemCount:
                                  movies!.length > 10 ? 15 : movies.length,
                            ),
                          ),
                        ],
                      );
                    });
              },
              separatorBuilder: (_, i) {
                if (i % 3 == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: BannerWidget(
                      adSize: AdSize.banner,
                      valueKey: ValueKey("movies-$i"),
                    ),
                  );
                }
                return const SizedBox(height: 15);
              },
            );
          },
        );
      },
    );
  }
}
