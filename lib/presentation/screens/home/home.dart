part of '../screens.dart';

bool kIsArabicLang = true;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildGlassTile({
    required Widget icon,
    required String arLabel,
    required String enLabel,
    required VoidCallback onTap,
    double fontSize = 15,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xB826333D),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0x45D5B055),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 10),
            Text(
              kIsArabicLang ? arLabel : enLabel,
              style: styleTitle.copyWith(
                fontSize: fontSize,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              kIsArabicLang ? enLabel : arLabel,
              style: styleBody.copyWith(
                fontSize: 11,
                color: const Color(0xFFE5C158),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x991A222A),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: const Color(0x40D5B055),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color(0xFFD5B055),
            size: 24,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF080B0F),
            Color(0xFF151F28),
            Color(0xFF281E0D),
            Color(0xFF0A0E13),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Top Header Row
          SizedBox(
            height: 54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      kIsArabicLang = !kIsArabicLang;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xCC23303A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0x88D5B055)),
                    ),
                    child: Text(
                      kIsArabicLang
                          ? "🌐 اللغة: العربية (EN)"
                          : "🌐 Lang: English (عربي)",
                      style: styleBody.copyWith(
                        color: const Color(0xFFFCE38A),
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        kIconSplash,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Alzaabi TV",
                      style: styleTitle.copyWith(
                        fontSize: 18,
                        color: const Color(0xFFFCE38A),
                      ),
                    ),
                  ],
                ),
                Text(
                  kIsArabicLang
                      ? "صلاحية الاشتراك الحالي: غير محدود"
                      : "Current playlist expires: unlimited",
                  style: styleBody.copyWith(
                    color: Colors.white,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Main 3-Column 8K Bento Layout
          Expanded(
            child: Row(
              children: [
                // Column 1: Tall Live TV Card
                Expanded(
                  flex: 11,
                  child: _buildGlassTile(
                    icon: const Icon(
                      FluentIcons.t_v_monitor_selected,
                      color: Color(0xFFD5B055),
                      size: 56,
                    ),
                    arLabel: "البث المباشر",
                    enLabel: "Live TV",
                    fontSize: 17,
                    onTap: () => router.pushNamed(screenLive),
                  ),
                ),
                const SizedBox(width: 12),

                // Column 2: 2x2 Grid (Movies, Series, Sports, Change Playlist)
                Expanded(
                  flex: 16,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildGlassTile(
                                icon: const Icon(
                                  FluentIcons.my_movies_t_v,
                                  color: Color(0xFFD5B055),
                                  size: 36,
                                ),
                                arLabel: "الأفلام",
                                enLabel: "Movies",
                                onTap: () => router.pushNamed(screenMovies),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildGlassTile(
                                icon: const Icon(
                                  FluentIcons.video,
                                  color: Color(0xFFD5B055),
                                  size: 36,
                                ),
                                arLabel: "المسلسلات",
                                enLabel: "Series",
                                onTap: () => router.pushNamed(screenSeries),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildGlassTile(
                                icon: const Icon(
                                  FontAwesomeIcons.futbol,
                                  color: Color(0xFFD5B055),
                                  size: 34,
                                ),
                                arLabel: "الرياضة",
                                enLabel: "Sports",
                                onTap: () => router.pushNamed(screenLive),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildGlassTile(
                                icon: const Icon(
                                  FluentIcons.bulleted_list,
                                  color: Color(0xFFD5B055),
                                  size: 36,
                                ),
                                arLabel: "تغيير القائمة",
                                enLabel: "Change Playlist",
                                onTap: () {
                                  context
                                      .read<SettingsCubit>()
                                      .disableMenu(true);
                                  context.read<AuthBloc>().add(AuthLogOut());
                                  router.goNamed(screenRegister);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Column 3: Right 8K Golden Preview Box + 3 Action Buttons
                Expanded(
                  flex: 21,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => router.pushNamed(screenLive),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const RadialGradient(
                                center: Alignment(-0.2, -0.2),
                                radius: 1.1,
                                colors: [
                                  Color(0xFF4B350C),
                                  Color(0xFF1F1605),
                                  Color(0xFF0A0804),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0x66D5B055),
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      kImageIntro,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.65),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0x88D5B055),
                                      ),
                                    ),
                                    child: Text(
                                      kIsArabicLang
                                          ? "▶ اضغط للبث المباشر 8K"
                                          : "▶ Tap for 8K Live TV",
                                      style: styleBody.copyWith(
                                        fontSize: 10.5,
                                        color: const Color(0xFFFCE38A),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 54,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildActionTile(
                                icon: FluentIcons.settings,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const SettingsPage(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionTile(
                                icon: FluentIcons.refresh,
                                onTap: () {
                                  router.pushNamed(screenDownload);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionTile(
                                icon: FluentIcons.sign_out,
                                onTap: () {
                                  context
                                      .read<SettingsCubit>()
                                      .disableMenu(true);
                                  context.read<AuthBloc>().add(AuthLogOut());
                                  router.goNamed(screenRegister);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kIsArabicLang
                    ? "Alzaabi TV — النسخة العربية المفعلة"
                    : "Alzaabi TV — Licensed Edition",
                style: styleBody.copyWith(
                  fontSize: 11.5,
                  color: const Color(0xFFD5B055),
                ),
              ),
              Text(
                "v$kAppVersion",
                style: styleTitle.copyWith(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
