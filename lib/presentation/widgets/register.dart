part of 'widgets.dart';

class IntroImageAnimated extends StatefulWidget {
  const IntroImageAnimated({super.key});

  @override
  State<IntroImageAnimated> createState() => _IntroImageAnimatedState();
}

class _IntroImageAnimatedState extends State<IntroImageAnimated> {
  bool isImage = true;
  ScrollController controller = ScrollController();

  _startAnimation() async {
    if (!mounted) return;
    const int second = 70;
    await Future.delayed(const Duration(milliseconds: 400));

    await controller.animateTo(
      isImage ? controller.position.maxScrollExtent : 0,
      duration: const Duration(seconds: second),
      curve: Curves.linear,
    );
    if (mounted) {
      setState(() {
        isImage = !isImage;
      });
      await _startAnimation();
    }
  }

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: getSize(context).width,
          height: getSize(context).height,
          child: SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            child: Image.asset(
              kImageIntro,
              width: getSize(context).width,
              height: getSize(context).height,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Opacity(
          opacity: .6,
          child: Container(
            width: getSize(context).width,
            height: getSize(context).height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kColorPrimary, kColorPrimaryDark],
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              kIconSplashSvg,
              width: getSize(context).width * .25,
              height: getSize(context).width * .25,
            ),
          ],
        ),
      ],
    );
  }
}

class CardM3U extends StatefulWidget {
  const CardM3U({super.key, required this.isLoading});

  final bool isLoading;

  @override
  State<CardM3U> createState() => _CardM3UState();
}

class _CardM3UState extends State<CardM3U> {
  final _name = TextEditingController();
  final _m3u = TextEditingController();

  //text: "http://iptvizle.cloud:8080/player_api.php?username=hangout&password=01ak061"

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardInputLoginTile(
          label: 'الاسم / Name',
          controller: _name,
        ),
        const SizedBox(height: 10),
        CardInputLoginTile(
          label: 'رابط M3U',
          controller: _m3u,
        ),
        const SizedBox(height: 20),
        CardLoginCancel(
          progress: widget.isLoading,
          onSave: () async {
            try {
              var txt = _m3u.text;
              if (txt.isEmpty) {
                showSoftToast("Enter your name and M3U/XTREME url");
                return;
              }

              if (isValidUrl(txt)) {
                Uri url = Uri.parse(txt);
                var parameters = url.queryParameters;

                final domain =
                    "${url.scheme}://${url.host}${url.hasPort ? ":${url.port}" : ""}";

                final username = parameters['username'].toString();
                final password = parameters['password'].toString();

                context.read<AuthBloc>().add(AuthRegister(
                      username,
                      password,
                      domain,
                      _name.text.isEmpty ? "user" : _name.text,
                      typeLogin: "XTREME",
                    ));
              } else {
                showSoftToast("Your url M3U/XTREME is wrong!!");
              }
            } catch (e) {
              debugPrint("Error: wrong m3u");
              showWarningToast("Error: wrong m3u");
            }
          },
          onClear: null,
        ),
      ],
    );
  }
}

class CardLoginCancel extends StatelessWidget {
  const CardLoginCancel(
      {super.key, required this.onSave, this.onClear, this.progress = false});

  final bool progress;

  final Function() onSave;
  final Function()? onClear;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: progress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onClear != null && !progress)
            SizedBox(
              width: 80,
              height: 23,
              child: Button(
                style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                onPressed: onClear,
                child: Center(
                  child: Text(
                    "Clear",
                    style: styleBody.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            height: 23,
            child: FilledButton(
              style: ButtonStyle(
                padding: ButtonState.all(EdgeInsets.zero),
              ),
              onPressed: onSave,
              child: Center(
                child: !progress
                    ? Text(
                        "Save",
                        style: styleBody.copyWith(
                          color: Colors.white,
                        ),
                      )
                    : LoadingAnimationWidget.staggeredDotsWave(
                        size: 20,
                        color: Colors.white,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CardXTREAM extends StatefulWidget {
  const CardXTREAM({super.key, required this.isLoading});

  final bool isLoading;

  @override
  State<CardXTREAM> createState() => _CardXTREAMState();
}

class _CardXTREAMState extends State<CardXTREAM> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _domain = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardInputLoginTile(
          label: 'اسم الحساب',
          controller: _name,
        ),
        const SizedBox(height: 10),
        CardInputLoginTile(
          label: 'السيرفر Domain',
          controller: _domain,
        ),
        const SizedBox(height: 10),
        CardInputLoginTile(
          label: 'المستخدم User',
          controller: _username,
        ),
        const SizedBox(height: 10),
        CardInputLoginTile(
          label: 'كلمة السر Pass',
          controller: _password,
        ),
        const SizedBox(height: 20),
        CardLoginCancel(
          onSave: () {
            if (_domain.text.trim().isEmpty ||
                _username.text.trim().isEmpty ||
                _password.text.trim().isEmpty) {
              showSoftToast("Enter all the XTREME Info");
              return;
            }

            final cleanDomain = _domain.text.trim().replaceAll(RegExp(r'/+$'), '');
            context.read<AuthBloc>().add(AuthRegister(
                _username.text.trim(),
                _password.text.trim(),
                cleanDomain,
                _name.text.trim().isEmpty ? "user" : _name.text.trim(),
                typeLogin: "XTREME"));
          },
          onClear: null,
        ),
      ],
    );
  }
}

class CardInputLoginTile extends StatelessWidget {
  const CardInputLoginTile({super.key, required this.label, this.controller});

  final String label;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: deviceIsWeb(context) ? 130 : 100,
          child: Text(
            label,
            style: styleBody,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 22,
            child: Center(
              child: TextBox(
                controller: controller,
                padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
                style: styleBody,
                cursorColor: kColorPrimary,
                cursorHeight: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardPlaylistTile extends StatelessWidget {
  const CardPlaylistTile(
      {super.key,
      required this.model,
      required this.onDelete,
      this.selected = true});

  final UserModel model;
  final Function() onDelete;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final controllerDelete = FlyoutController();
    const double sizeTxt = 10;
    return SizedBox(
      height: kIsWeb ? 100 : 85,
      child: ListTile.selectable(
        title: Text(
          model.accountName,
          style: styleTitle.copyWith(
            fontSize: deviceIsWeb(context) ? 11 : 14,
          ),
        ),
        trailing: Center(
          child: FlyoutTarget(
            controller: controllerDelete,
            child: IconButton(
              icon: const Icon(FluentIcons.delete),
              onPressed: () {
                controllerDelete.showFlyout(
                  barrierColor: Colors.black.withOpacity(0.1),
                  builder: (context) {
                    return CardFluentDeletePlaylist(
                      onDelete: onDelete,
                    );
                  },
                );
              },
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Type: ',
                    style: styleBody.copyWith(
                      color: Colors.grey[110],
                      fontSize: sizeTxt,
                    ),
                  ),
                  TextSpan(
                    text: model.typeLogin,
                    style: styleBody.copyWith(
                      color: Colors.white,
                      fontSize: sizeTxt,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Updated: ',
                    style: styleBody.copyWith(
                      color: Colors.grey[110],
                      fontSize: sizeTxt,
                    ),
                  ),
                  TextSpan(
                    text: 'Yesterday at 7:39 PM',
                    style: styleBody.copyWith(
                      color: Colors.white,
                      fontSize: sizeTxt,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: Center(
          child: CircleAvatar(
            backgroundColor: Colors.grey[130],
            radius: 20,
            child: CircleAvatar(
              radius: 19.5,
              backgroundColor: Colors.grey,
              child: Text(
                model.accountName[0],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        selected: selected,
        selectionMode: ListTileSelectionMode.single,
        onPressed: () {
          debugPrint("Clicked");
          context.read<AuthBloc>().add(AuthRegister(
                model.userInfo!.username ?? "",
                model.userInfo!.password ?? "",
                model.domain,
                model.accountName,
                addToPlayList: false,
                typeLogin: model.typeLogin,
              ));
        },
        onSelectionChange: (v) {},
      ),
    );
  }
}

class CardFluentDeletePlaylist extends StatelessWidget {
  const CardFluentDeletePlaylist({super.key, required this.onDelete});

  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return FlyoutContent(
      child: SizedBox(
        width: getSize(context).width * 0.3,
        child: CommandBarCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to proceed?\nDeleting this playlist will result in the deletion of all saved data associated with it.',
                style: styleBody,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    child: Text(
                      'Cancel',
                      style: styleBody.copyWith(
                        fontSize: deviceIsWeb(context) ? 10 : 12.5,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  Button(
                    onPressed: onDelete,
                    child: Text(
                      'Remove',
                      style: styleBody.copyWith(
                        fontSize: deviceIsWeb(context) ? 10 : 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardMyPlaylists extends StatefulWidget {
  const CardMyPlaylists({super.key, required this.isLoading});

  final bool isLoading;

  @override
  State<CardMyPlaylists> createState() => _CardMyPlaylistsState();
}

class _CardMyPlaylistsState extends State<CardMyPlaylists> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: AuthLocale.getListUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data;

          return ListView.builder(
            itemCount: users!.length,
            itemBuilder: (_, index) {
              final user = users[index];
              return CardPlaylistTile(
                model: users[index],
                onDelete: () {
                  context
                      .read<AuthBloc>()
                      .add(DeleteUserEvent(accountName: user.accountName));

                  setState(() {});
                  //close dialog
                  Navigator.pop(context);
                },
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
