part of 'widgets.dart';

class CardMovieItem extends StatelessWidget {
  const CardMovieItem(
      {super.key,
      required this.onTap,
      required this.image,
      required this.name,
      this.rate});

  final Function() onTap;
  final String image;
  final String name;
  final double? rate;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onTap,
      builder: (context, Set<ButtonStates> state) {
        final bool isHovered = state.isHovering || state.isFocused;
        return Container(
          width: getSize(context).width * .13,
          constraints: const BoxConstraints(maxWidth: 135),
          margin: EdgeInsets.symmetric(vertical: isHovered ? 0 : 3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, ie) {
                    return const CardNoImage();
                  },
                  errorWidget: (_, i, e) {
                    return const CardNoImage();
                  },
                ),
                Container(
                  width: getSize(context).width,
                  height: getSize(context).height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        end: Alignment.bottomLeft,
                        begin: Alignment.topRight,
                        stops: isHovered ? null : [.3, .3, .8],
                        colors: isHovered
                            ? [
                                Colors.black.withOpacity(.4),
                                kColorPrimaryDark.withOpacity(.8),
                              ]
                            : [
                                Colors.black.withOpacity(.1),
                                Colors.black.withOpacity(.2),
                                Colors.black.withOpacity(1),
                              ]),
                  ),
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    name,
                    maxLines: 3,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: kFontFamily,
                    ),
                  ),
                ),
                if (isHovered)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Icon(
                          FluentIcons.play_solid,
                          size: 19,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GFRating(
                        value: rate ?? 0,
                        size: 12,
                        color: Colors.white,
                        borderColor: Colors.grey,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CardChannelTile extends StatelessWidget {
  const CardChannelTile({super.key, required this.label, required this.onTap});

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            fontFamily: kFontFamily,
          ),
        ),
        Button(
          onPressed: onTap,
          child: const Text(
            'Show More',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              fontFamily: kFontFamily,
            ),
          ),
        ),
      ],
    );
  }
}

class ThumpMovie extends StatelessWidget {
  const ThumpMovie({super.key, this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: image ?? "",
          width: getSize(context).width,
          height: getSize(context).height,
          fit: BoxFit.cover,
          placeholder: (_, i) {
            return const CardNoImage();
          },
          errorWidget: (_, i, e) {
            return const CardNoImage();
          },
        ),

        //Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(.4),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SeasonButton extends StatelessWidget {
  const SeasonButton(
      {super.key,
      required this.label,
      required this.onChange,
      required this.isSelected});

  final String label;
  final Function(bool) onChange;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ToggleButton(
      checked: isSelected,
      onChanged: onChange,
      style: ToggleButtonThemeData(
        uncheckedButtonStyle: ButtonStyle(
          backgroundColor: ButtonState.all(Colors.white.withOpacity(.2)),

          /* border: ButtonState.all(const BorderSide(
            color: Colors.white,
            width: 1,
          )),*/
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: kFontFamily,
          ),
        ),
      ),
    );
  }
}

class CardEpisode extends StatelessWidget {
  final Episode? model;
  final bool isSelected;
  final Function() onTap;

  const CardEpisode(
      {super.key,
      required this.model,
      this.isSelected = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const SizedBox();
    }
    return HoverButton(
      onPressed: onTap,
      builder: (context, state) {
        final isFocus = state.isFocused || state.isHovering;

        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: model?.info?.movieImage ?? "",
                    width: getSize(context).width,
                    height: deviceIsWeb(context) ? 130 : 100,
                    fit: BoxFit.cover,
                    placeholder: (_, ie) {
                      return const CardNoImage();
                    },
                    errorWidget: (_, i, e) {
                      return const CardNoImage();
                    },
                  ),
                ),
                if (isSelected || isFocus)
                  Container(
                    width: getSize(context).width,
                    height: deviceIsWeb(context) ? 130 : 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:
                          FluentTheme.of(context).accentColor.withOpacity(.1),
                    ),
                  ),
                //if (isFocus)
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    model!.title ?? "Episode ${model!.episodeNum}",
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            /*Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Episode ${model.episodeNum}",
                style: TextStyle(
                  fontSize: deviceIsWeb(context) ? 11 : 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),*/
          ],
        );
      },
    );
  }
}

class CardButtonTrailer extends StatelessWidget {
  const CardButtonTrailer({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getSize(context).width * .15,
      height: deviceIsWeb(context) ? 35 : 30,
      child: FilledButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: ButtonState.all(Colors.red.light),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.youtube,
              color: Colors.white,
              size: 17,
            ),
            SizedBox(width: 5),
            Text(
              "Trailer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
