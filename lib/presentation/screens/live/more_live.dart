part of '../screens.dart';

class MoreLivePage extends StatelessWidget {
  const MoreLivePage({super.key, required this.id, required this.name});
  final String id, name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<ChannelLive>>(
          future: LiveLocale.getLiveById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final lives = snapshot.data;

              return BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  final searchKey = state.searchKey;
                  final searchLives = lives!
                      .where((element) =>
                          element.name!.toLowerCase().contains(searchKey))
                      .toList();

                  final finalLive = searchKey.isEmpty ? lives : searchLives;

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Wrap(
                            spacing: 13,
                            runSpacing: 15,
                            children: [
                              for (int i = 0; i < finalLive.length; i++)
                                Container(
                                  constraints:
                                      const BoxConstraints(maxHeight: 100),
                                  height: getSize(context).height *
                                      (deviceIsWeb(context) ? .15 : .18),
                                  child: CardHomeFavChannelsItem(
                                      model: finalLive[i]),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const BannerWidget(
                        adSize: AdSize.banner,
                        valueKey: ValueKey("more-lices"),
                      ),
                    ],
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),

        ///GO BACK
        const Positioned(
          top: 0,
          right: 5,
          child: BackButtonX(),
        ),
      ],
    );
  }
}
