part of '../screens.dart';

class SeriePage extends StatelessWidget {
  const SeriePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, stateSearch) {
        final searchKey = stateSearch.searchKey;

        return BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            final channels = state.series;

            final searchChannels = state.series
                .where((element) =>
                    element.categoryName!.toLowerCase().contains(searchKey))
                .toList();

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              itemBuilder: (_, i) {
                final serieChannel =
                    searchKey.isEmpty ? channels[i] : searchChannels[i];

                //  debugPrint("CATY: ${serieChannel.categoryName} ${serieChannel.categoryId}");

                return FutureBuilder<List<ChannelSerie>>(
                  future: TvSHowsLocale.getTvSHowsByCaty(
                    serieChannel.categoryId.toString(),
                    page: 1,
                    pageSize: 10,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final List<ChannelSerie>? tvshows = snapshot.data;

                      // debugPrint("series is here: ${tvshows!.length}");

                      return Column(
                        children: [
                          CardChannelTile(
                            label: serieChannel.categoryName ?? "",
                            onTap: () {
                              context
                                  .read<SearchCubit>()
                                  .addSearch("", null, true);
                              router.pushNamed(screenMoreSeries,
                                  queryParameters: {
                                    "id": serieChannel.categoryId!,
                                    "name": serieChannel.categoryName!,
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
                                final model = tvshows[i];

                                return CardMovieItem(
                                    image: model.cover ?? "",
                                    name: model.name ?? "",
                                    rate:
                                        double.parse(model.rating5based ?? "0"),
                                    onTap: () {
                                      router.pushNamed(screenSerieDetails,
                                          extra: model,
                                          queryParameters: {
                                            "channel_name": serieChannel
                                                .categoryName
                                                .toString(),
                                          }).then((value) {
                                        loadInterstitialAd();
                                      });
                                    });
                              },
                              separatorBuilder: (_, i) {
                                return SizedBox(
                                    width: deviceIsWeb(context) ? 15 : 10);
                              },
                              itemCount: tvshows!.length,
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                );
              },
              separatorBuilder: (_, i) {
                if (i % 3 == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: BannerWidget(
                      adSize: AdSize.banner,
                      valueKey: ValueKey("series-$i"),
                    ),
                  );
                }
                return const SizedBox(height: 15);
              },
              itemCount:
                  searchKey.isEmpty ? channels.length : searchChannels.length,
            );
          },
        );
      },
    );
  }
}
