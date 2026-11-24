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
    if (!mounted || !controller.hasClients) return;

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
          opacity: .45,
          child: Container(
            width: getSize(context).width,
            height: getSize(context).height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF090C10), kColorPrimaryDark],
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                kIconSplash,
                width: getSize(context).width * .20,
                height: getSize(context).width * .20,
                fit: BoxFit.cover,
              ),
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
  State<CardM3U> createState() => CardM3UState();
}

class CardM3UState extends State<CardM3U> {
  final _name = TextEditingController();
  final _m3u = TextEditingController();

  void clearFieldsForNewCode() {
    setState(() {
      _name.clear();
      _m3u.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardInputLoginTile(
          label: 'الاسم (اختياري)',
          controller: _name,
        ),
        const SizedBox(height: 10),
        CardInputLoginTile(
          label: 'رابط M3U',
          controller: _m3u,
        ),
        const SizedBox(height: 16),
        CardLoginCancel(
          progress: widget.isLoading,
          onClear: clearFieldsForNewCode,
          onSave: () async {
            try {
              var txt = _m3u.text.trim().replaceAll(RegExp(r'\s+'), '');
              if (txt.isEmpty) {
                showSoftToast("أدخل رابط M3U أولاً");
                return;
              }

              if (isValidUrl(txt)) {
                Uri url = Uri.parse(txt);
                var parameters = url.queryParameters;

                final domain =
                    "${url.scheme}://${url.host}${url.hasPort ? ":${url.port}" : ""}";

                final username = (parameters['username'] ?? '').toString();
                final password = (parameters['password'] ?? '').toString();

                final accName = _name.text.trim().isEmpty
                    ? "M3U ($username)"
                    : _name.text.trim();

                context.read<AuthBloc>().add(AuthRegister(
                      username,
                      password,
                      domain,
                      accName,
                      typeLogin: "XTREME",
                    ));
              } else {
                showSoftToast("الرابط غير صحيح، تأكد من نسخ الرابط كاملاً");
              }
            } catch (e) {
              debugPrint("Error: wrong m3u");
              showWarningToast("Error: wrong m3u");
            }
          },
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
              width: 95,
              height: 28,
              child: Button(
                style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                onPressed: onClear,
                child: Center(
                  child: Text(
                    "تفريغ + جديد",
                    style: styleBody.copyWith(
                      color: Colors.white,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 10),
          SizedBox(
            width: 115,
            height: 28,
            child: FilledButton(
              style: ButtonStyle(
                padding: ButtonState.all(EdgeInsets.zero),
              ),
              onPressed: onSave,
              child: Center(
                child: !progress
                    ? Text(
                        "حفظ وتشغيل",
                        style: styleBody.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    : LoadingAnimationWidget.staggeredDotsWave(
                        size: 20,
                        color: Colors.black,
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
  State<CardXTREAM> createState() => CardXTREAMState();
}

class CardXTREAMState extends State<CardXTREAM> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _domain = TextEditingController();

  void clearFieldsForNewCode() {
    setState(() {
      _name.clear();
      _domain.clear();
      _username.clear();
      _password.clear();
    });
  }

  Future<void> _smartPasteFromClipboard() async {
    try {
      final data = await Clipboard.getData('text/plain');
      final text = (data?.text ?? '').trim();
      if (text.isEmpty) {
        showSoftToast("الحافظة فارغة — انسخ رسالة الكود أولاً");
        return;
      }

      // 1) Check if text contains an M3U get.php link with username=...&password=...
      final m3uMatch = RegExp(
              r'(https?:\/\/[^\s]+\/get\.php\?[^\s]+)',
              caseSensitive: false)
          .firstMatch(text);
      if (m3uMatch != null) {
        final uri = Uri.parse(m3uMatch.group(1)!);
        _domain.text =
            "${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}";
        _username.text = uri.queryParameters['username'] ?? _username.text;
        _password.text = uri.queryParameters['password'] ?? _password.text;
      }

      // 2) Extract explicit username / password / url lines from WhatsApp message
      final userMatch = RegExp(r'username\s*[:=]\s*([A-Za-z0-9_.-]+)',
              caseSensitive: false)
          .firstMatch(text);
      final passMatch = RegExp(r'password\s*[:=]\s*([A-Za-z0-9_.-]+)',
              caseSensitive: false)
          .firstMatch(text);
      final urlMatch =
          RegExp(r'(https?:\/\/[A-Za-z0-9_.-]+(?::\d+)?)', caseSensitive: false)
              .allMatches(text)
              .map((m) => m.group(1)!)
              .toList();

      if (userMatch != null) _username.text = userMatch.group(1)!;
      if (passMatch != null) _password.text = passMatch.group(1)!;
      if (urlMatch.isNotEmpty) {
        // Prefer uscahd.xyz if present in the message
        final preferred = urlMatch.firstWhere(
          (u) => u.contains("uscahd.xyz") && !u.contains("apps."),
          orElse: () => urlMatch.first,
        );
        _domain.text = preferred;
      }

      if (_name.text.trim().isEmpty && _username.text.isNotEmpty) {
        _name.text = "كود (${_username.text})";
      }
      setState(() {});
      showSoftToast("تم لصق وتعبئة بيانات الكود تلقائياً ✓");
    } catch (e) {
      showSoftToast("تعذر اللصق التلقائي: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Button(
            onPressed: _smartPasteFromClipboard,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FluentIcons.paste, size: 13, color: Color(0xFFFCE38A)),
                const SizedBox(width: 6),
                Text(
                  "📋 لصق ذكي لكود الواتساب بالكامل",
                  style: styleBody.copyWith(
                    fontSize: 11,
                    color: const Color(0xFFFCE38A),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        CardInputLoginTile(
          label: 'اسم الكود (اختياري)',
          controller: _name,
        ),
        const SizedBox(height: 8),
        CardInputLoginTile(
          label: 'السيرفر URL',
          controller: _domain,
        ),
        const SizedBox(height: 8),
        CardInputLoginTile(
          label: 'المستخدم User',
          controller: _username,
        ),
        const SizedBox(height: 8),
        CardInputLoginTile(
          label: 'كلمة السر Pass',
          controller: _password,
        ),
        const SizedBox(height: 14),
        CardLoginCancel(
          progress: widget.isLoading,
          onClear: clearFieldsForNewCode,
          onSave: () {
            if (_domain.text.trim().isEmpty ||
                _username.text.trim().isEmpty ||
                _password.text.trim().isEmpty) {
              showSoftToast("أدخل رابط السيرفر واسم المستخدم وكلمة السر");
              return;
            }

            final cleanDomain =
                _domain.text.trim().replaceAll(RegExp(r'/+$'), '');
            final cleanUser = _username.text.trim();
            final accName = _name.text.trim().isEmpty
                ? "كود ($cleanUser)"
                : _name.text.trim();

            context.read<AuthBloc>().add(AuthRegister(
                  cleanUser,
                  _password.text.trim(),
                  cleanDomain,
                  accName,
                  typeLogin: "XTREME",
                ));
          },
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
          width: deviceIsWeb(context) ? 130 : 105,
          child: Text(
            label,
            style: styleBody.copyWith(fontSize: 11.5),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 26,
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
    const double sizeTxt = 10.5;
    final uname = model.userInfo?.username ?? "";
    return SizedBox(
      height: kIsWeb ? 100 : 88,
      child: ListTile.selectable(
        title: Text(
          model.accountName,
          style: styleTitle.copyWith(
            fontSize: deviceIsWeb(context) ? 11 : 13.5,
            color: const Color(0xFFFCE38A),
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
            const SizedBox(height: 6),
            Text(
              "User: $uname  •  ${model.domain}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: styleBody.copyWith(
                color: Colors.white,
                fontSize: sizeTxt,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              "اضغط لتشغيل هذا الكود مباشرة (${model.typeLogin})",
              style: styleBody.copyWith(
                color: const Color(0xFFD5B055),
                fontSize: sizeTxt,
              ),
            ),
          ],
        ),
        leading: Center(
          child: CircleAvatar(
            backgroundColor: kColorPrimary,
            radius: 19,
            child: Text(
              model.accountName.isNotEmpty
                  ? model.accountName[0].toUpperCase()
                  : "A",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        selected: selected,
        selectionMode: ListTileSelectionMode.single,
        onPressed: () {
          context.read<AuthBloc>().add(AuthRegister(
                model.userInfo?.username ?? "",
                model.userInfo?.password ?? "",
                model.domain,
                model.accountName,
                addToPlayList: true,
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
                'هل تريد حذف هذا الكود المحفوظ نهائياً؟',
                style: styleBody,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    child: Text(
                      'إلغاء',
                      style: styleBody.copyWith(
                        fontSize: deviceIsWeb(context) ? 10 : 12,
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
                      'حذف',
                      style: styleBody.copyWith(
                        fontSize: deviceIsWeb(context) ? 10 : 12,
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
  const CardMyPlaylists({super.key, required this.isLoading, this.onAddNewTap});

  final bool isLoading;
  final VoidCallback? onAddNewTap;

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
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "لا توجد أكواد محفوظة بعد",
                    style: styleBody,
                  ),
                  const SizedBox(height: 10),
                  if (widget.onAddNewTap != null)
                    FilledButton(
                      onPressed: widget.onAddNewTap,
                      child: const Text("إضافة كود جديد +"),
                    ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) {
              final user = users[index];
              return CardPlaylistTile(
                model: user,
                onDelete: () {
                  context
                      .read<AuthBloc>()
                      .add(DeleteUserEvent(accountName: user.accountName));

                  setState(() {});
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
