part of '../screens.dart';

class MoreMoviesPage extends StatelessWidget {
  const MoreMoviesPage({super.key, required this.id, required this.name});

  final String id, name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<ChannelMovie>>(
            future: MoviesLocale.getMoviesByCaty(id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              final movies = snapshot.data;
              return BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  final searchKey = state.searchKey;
                  final searchMovies = movies!
                      .where((element) =>
                          element.name!.toLowerCase().contains(searchKey))
                      .toList();

                  final list = searchKey.isEmpty ? movies : searchMovies;

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (int i = 0; i < list.length; i++)
                                SizedBox(
                                  height: getSize(context).height *
                                      (deviceIsWeb(context) ? .25 : .33),
                                  child: CardMovieItem(
                                    name: list[i].name ?? "",
                                    image: list[i].streamIcon ?? "",
                                    rate: double.tryParse(
                                            list[i].rating5based ?? "0") ??
                                        0.0,
                                    onTap: () {
                                      router.pushNamed(
                                        screenMoviesDetails,
                                        queryParameters: {
                                          "channel_name": name,
                                        },
                                        extra: list[i],
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
                        valueKey: ValueKey("more-movies"),
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
