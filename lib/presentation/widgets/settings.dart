part of 'widgets.dart';

class SettingTileButton extends StatelessWidget {
  const SettingTileButton(
      {super.key,
      required this.icon,
      required this.color,
      required this.label,
      required this.onTap,
      required this.isSelected,
      this.isLoading = false,
      this.status});

  final IconData icon;
  final Color color;
  final String label;
  final Function() onTap;
  final bool isSelected;
  final bool isLoading;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return ListTile.selectable(
      title: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 11,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: deviceIsWeb(context) ? 11 : 12,
            ),
          ),
          const Spacer(),
          if (isLoading)
            Text(
              status ?? "",
              style: styleBody.copyWith(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          if (isLoading) const SizedBox(width: 5),
          if (isLoading)
            LoadingAnimationWidget.inkDrop(
              color: kColorPrimary,
              size: 18,
            ),
          if (!isLoading)
            Icon(
              FluentIcons.chevron_right,
              size: 8,
              color: Colors.grey[60],
            )
        ],
      ),
      selected: isSelected,
      selectionMode: ListTileSelectionMode.single,
      onPressed: onTap,
      onSelectionChange: (selected) {},
    );
  }
}

class CardSettingInfo extends StatelessWidget {
  const CardSettingInfo(
      {super.key,
      required this.title,
      required this.icon,
      required this.label,
      required this.body,
      required this.onTap,
      required this.color});

  final String title;
  final IconData icon;
  final String label, body;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[220],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(UniversalPlatform.isDesktopOrWeb ? 10 : 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveRowColumn(
                rowMainAxisAlignment: MainAxisAlignment.center,
                layout: UniversalPlatform.isDesktopOrWeb
                    ? ResponsiveRowColumnType.ROW
                    : ResponsiveRowColumnType.COLUMN,
                children: [
                  ResponsiveRowColumnItem(
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 11,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    child: UniversalPlatform.isDesktopOrWeb
                        ? const SizedBox(width: 10)
                        : const SizedBox(height: 5),
                  ),
                  ResponsiveRowColumnItem(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  //
                ],
              ),
              SizedBox(height: UniversalPlatform.isDesktopOrWeb ? 10 : 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[90],
                  fontSize: deviceIsWeb(context) ? 10 : 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardOfferType1 extends StatelessWidget {
  const CardOfferType1({super.key, required this.model});

  final OfferSettings model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getSize(context).width * (deviceIsWeb(context) ? .2 : .24),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                model.icon,
                color: model.color,
                size: deviceIsWeb(context) ? 17 : 15,
              ),
              const SizedBox(width: 10),
              Text(
                model.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 10),
          Text(
            model.body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[90],
            ),
          ),
        ],
      ),
    );
  }
}

class CardOffer extends StatelessWidget {
  const CardOffer(
      {super.key,
      required this.days,
      required this.price,
      required this.onTap});

  final String days;
  final String price;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: kColorOffer.withOpacity(.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: kColorOffer,
              width: 2,
            )),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        child: Column(
          children: [
            Text(
              days,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Months',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),
            Text(
              '$price / Monthly',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
