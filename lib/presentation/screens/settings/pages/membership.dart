part of '../../screens.dart';

class MemberShip extends StatelessWidget {
  const MemberShip({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                kAppNamePro.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kColorPrimary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(FontAwesomeIcons.plus),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text(
              "Get the premium today and enjoy watching your content as never before.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 15),

          ///Offers
          Row(
            children: [
              CardOffer(
                onTap: () {},
                days: "1",
                price: "US\$2,99",
              ),
              const SizedBox(width: 15),
              CardOffer(
                onTap: () {},
                days: "12",
                price: "US\$22,99",
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Text(
              "Cancel any time",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
              ),
            ),
          ),

          const Text(
            "Premium Features",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: getSize(context).width,
            height: getSize(context).height * (deviceIsWeb(context) ? .11 : .2),
            constraints: const BoxConstraints(maxHeight: 140),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                return CardOfferType1(model: offersSetting[i]);
              },
              separatorBuilder: (_, i) {
                return const SizedBox(width: 13);
              },
              itemCount: offersSetting.length,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
