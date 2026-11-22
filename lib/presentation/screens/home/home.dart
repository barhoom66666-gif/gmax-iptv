part of '../screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardRandomMovie(),
                  SizedBox(height: 15),
                  BannerWidget(
                    adSize: AdSize.fullBanner,
                    valueKey: ValueKey("home"),
                  ),

                  ///Continue Watching
                  CardContinueWatching(),

                  ///Fav Channels
                  CardHomeRecentChannels(),

                  ///Fav Movies

                  CardFavMovies(),

                  ///Fav Tv SHows
                  CardFavTvSHows(),

                  SizedBox(height: 15),
                ],
              ),
            ),
          ),

          ///Offers
          /*  if (UniversalPlatform.isDesktopOrWeb && false)
            Container(
              constraints: const BoxConstraints(
                maxWidth: 350,
                minWidth: 200,
              ),
              margin: const EdgeInsets.only(left: 10),
              width: getSize(context).width * .25,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (_, i) {
                        return const CardOurOfferItem();
                      },
                      separatorBuilder: (_, i) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: 2,
                    ),
                  ],
                ),
              ),
            ),*/
        ],
      ),
    );
  }
}
