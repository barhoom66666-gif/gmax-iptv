part of '../screens.dart';

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final channels = state.lives;

        return BlocBuilder<SearchCubit, SearchState>(
          builder: (context, stateSearch) {
            final searchKey = stateSearch.searchKey;
            List<CategoryModel> searchChannels = channels
                .where((element) => element.categoryName!
                    .toLowerCase()
                    .contains(searchKey.toLowerCase()))
                .toList();

            return ListView.separated(
              itemCount:
                  searchKey.isEmpty ? channels.length : searchChannels.length,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              itemBuilder: (_, i) {
                final model =
                    searchKey.isEmpty ? channels[i] : searchChannels[i];
                return FutureBuilder<List<ChannelLive>>(
                    future: LiveLocale.getLiveById(
                      model.categoryId.toString(),
                      page: 1,
                      pageSize: 10,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }

                      final lives = snapshot.data;
                      return Column(
                        children: [
                          CardChannelTile(
                            label: model.categoryName ?? "",
                            onTap: () {
                              context
                                  .read<SearchCubit>()
                                  .addSearch("", null, true);
                              router
                                  .pushNamed(screenLiveMore, queryParameters: {
                                "name": model.categoryName ?? "",
                                "id": model.categoryId ?? "",
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: getSize(context).width,
                            height: getSize(context).height *
                                (deviceIsWeb(context) ? .15 : .18),
                            constraints: const BoxConstraints(maxHeight: 100),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, i) {
                                final liveModel = lives[i];
                                return CardHomeFavChannelsItem(
                                    model: liveModel);
                              },
                              separatorBuilder: (_, i) {
                                return SizedBox(
                                    width: deviceIsWeb(context) ? 15 : 10);
                              },
                              itemCount: lives!.length,
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
                      valueKey: ValueKey("lives-$i"),
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
