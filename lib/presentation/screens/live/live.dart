part of '../screens.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  static const String _kFavCategoryId = "__FAV_LIVE__";
  String? _selectedCategoryId;
  Future<List<ChannelLive>>? _channelsFuture;

  void _selectCategory(String categoryId) {
    if (_selectedCategoryId == categoryId &&
        categoryId != _kFavCategoryId &&
        _channelsFuture != null) {
      return;
    }
    setState(() {
      _selectedCategoryId = categoryId;
      if (categoryId != _kFavCategoryId) {
        _channelsFuture = LiveLocale.getLiveById(categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final categories = state.lives;
        if (categories.isEmpty) {
          return Center(
            child: Text(
              "لا توجد باقات بث مباشر — اضغط تحديث من الإعدادات",
              style: styleTitle.copyWith(fontSize: 14),
            ),
          );
        }

        if (_selectedCategoryId == null ||
            (_selectedCategoryId != _kFavCategoryId &&
                !categories.any((c) => c.categoryId == _selectedCategoryId))) {
          _selectedCategoryId = categories.first.categoryId.toString();
          _channelsFuture = LiveLocale.getLiveById(_selectedCategoryId!);
        }

        return BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favState) {
            return BlocBuilder<SearchCubit, SearchState>(
              builder: (context, stateSearch) {
                final searchKey = stateSearch.searchKey.trim().toLowerCase();
                final isFavSelected = _selectedCategoryId == _kFavCategoryId;

                return Row(
                  children: [
                    // Categories Sidebar (with Pinned Favorites at #1)
                    Container(
                      width: 215,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10161D),
                        border: Border(
                          right: BorderSide(color: Color(0x33D5B055), width: 1),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: categories.length + 1,
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 6),
                        itemBuilder: (_, idx) {
                          if (idx == 0) {
                            return GestureDetector(
                              onTap: () => _selectCategory(_kFavCategoryId),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: isFavSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFFE5C158),
                                            Color(0xFF9A711C)
                                          ],
                                        )
                                      : null,
                                  color: isFavSelected
                                      ? null
                                      : const Color(0xFF261D0B),
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: const Color(0xFFFCE38A),
                                    width: isFavSelected ? 1.6 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidHeart,
                                      size: 13,
                                      color: isFavSelected
                                          ? const Color(0xFF090C10)
                                          : const Color(0xFFFF4D6D),
                                    ),
                                    const SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        "⭐ القنوات المفضلة (${favState.lives.length})",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: kFontFamily,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isFavSelected
                                              ? const Color(0xFF090C10)
                                              : const Color(0xFFFCE38A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final cat = categories[idx - 1];
                          final isSelected =
                              cat.categoryId.toString() == _selectedCategoryId;
                          return GestureDetector(
                            onTap: () =>
                                _selectCategory(cat.categoryId.toString()),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 9),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFFD5B055),
                                          Color(0xFF9A711C)
                                        ],
                                      )
                                    : null,
                                color:
                                    isSelected ? null : const Color(0xFF1A232C),
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFFCE38A)
                                      : const Color(0x22D5B055),
                                ),
                              ),
                              child: Text(
                                cat.categoryName ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: kFontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? const Color(0xFF090C10)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Channels Virtualized Grid
                    Expanded(
                      child: isFavSelected
                          ? _buildLiveGrid(favState.lives, searchKey,
                              isFavTab: true)
                          : FutureBuilder<List<ChannelLive>>(
                              future: _channelsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CardDetailsLoading());
                                }
                                return _buildLiveGrid(
                                    snapshot.data ?? [], searchKey);
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLiveGrid(List<ChannelLive> allChannels, String searchKey,
      {bool isFavTab = false}) {
    final filtered = searchKey.isEmpty
        ? allChannels
        : allChannels
            .where((c) => (c.name ?? "").toLowerCase().contains(searchKey))
            .toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          isFavTab
              ? "لا توجد قنوات في المفضلة بعد — اضغط على علامة القلب ♥ أعلى أي قناة لإضافتها هنا"
              : "لا توجد قنوات في هذه الباقة",
          style: styleBody.copyWith(fontSize: 13, color: const Color(0xFFFCE38A)),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 175,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        return CardHomeFavChannelsItem(model: filtered[i]);
      },
    );
  }
}
