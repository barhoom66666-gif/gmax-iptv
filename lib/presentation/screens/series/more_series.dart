part of '../screens.dart';

class MoreSeriesPage extends StatelessWidget {
  const MoreSeriesPage({super.key, required this.id, required this.name});

  final String id, name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<ChannelSerie>>(
            future: TvSHowsLocale.getTvSHowsByCaty(id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              final movies = snapshot.data;
              return BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  final searchKey = state.searchKey;

                  final searchMovie = movies!
                      .where((element) =>
                          element.name!.toLowerCase().contains(searchKey))
                      .toList();

                  final finalList = searchKey.isEmpty ? movies : searchMovie;

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (int i = 0; i < finalList.length; i++)
                                SizedBox(
                                  height: getSize(context).height *
                                      (deviceIsWeb(context) ? .25 : .33),
                                  child: CardMovieItem(
                                    name: finalList[i].name ?? "",
                                    image: finalList[i].cover ?? "",
                                    rate: double.parse(
                                        finalList[i].rating5based ?? "0"),
                                    onTap: () {
                                      router.pushNamed(
                                        screenSerieDetails,
                                        queryParameters: {
                                          "id": finalList[i].categoryId!,
                                          "name": name,
                                        },
                                        extra: finalList[i],
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const BannerWidget(
                        adSize: AdSize.banner,
                        valueKey: ValueKey("more-series"),
                      ),
                    ],
                  );
                },
              );
            }),

        ///GO BACK
        const Positioned(
          top: 5,
          right: 5,
          child: BackButtonX(),
        ),
      ],
    );
  }
}
