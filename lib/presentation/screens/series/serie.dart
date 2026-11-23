part of '../screens.dart';

class SeriePage extends StatefulWidget {
  const SeriePage({super.key});

  @override
  State<SeriePage> createState() => _SeriePageState();
}

class _SeriePageState extends State<SeriePage> {
  String? _selectedCategoryId;
  String _selectedCategoryName = "";
  Future<List<ChannelSerie>>? _seriesFuture;

  void _selectCategory(CategoryModel cat) {
    final cid = cat.categoryId.toString();
    if (_selectedCategoryId == cid && _seriesFuture != null) return;
    setState(() {
      _selectedCategoryId = cid;
      _selectedCategoryName = cat.categoryName ?? "";
      _seriesFuture = TvSHowsLocale.getTvSHowsByCaty(cid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final categories = state.series;
        if (categories.isEmpty) {
          return Center(
            child: Text(
              "لا توجد باقات مسلسلات — اضغط تحديث من الإعدادات",
              style: styleTitle.copyWith(fontSize: 14),
            ),
          );
        }

        if (_selectedCategoryId == null ||
            !categories.any((c) => c.categoryId == _selectedCategoryId)) {
          _selectedCategoryId = categories.first.categoryId.toString();
          _selectedCategoryName = categories.first.categoryName ?? "";
          _seriesFuture = TvSHowsLocale.getTvSHowsByCaty(_selectedCategoryId!);
        }

        return BlocBuilder<SearchCubit, SearchState>(
          builder: (context, stateSearch) {
            final searchKey = stateSearch.searchKey.trim().toLowerCase();

            return Row(
              children: [
                // Series Categories Sidebar
                Container(
                  width: 210,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10161D),
                    border: Border(
                      right: BorderSide(color: Color(0x33D5B055), width: 1),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: categories.length,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    itemBuilder: (_, idx) {
                      final cat = categories[idx];
                      final isSelected = cat.categoryId.toString() == _selectedCategoryId;
                      return GestureDetector(
                        onTap: () => _selectCategory(cat),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [Color(0xFFD5B055), Color(0xFF9A711C)],
                                  )
                                : null,
                            color: isSelected ? null : const Color(0xFF1A232C),
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
                              color: isSelected ? const Color(0xFF090C10) : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Series Virtualized Grid (Shows ALL series in the selected category)
                Expanded(
                  child: FutureBuilder<List<ChannelSerie>>(
                    future: _seriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CardDetailsLoading());
                      }
                      final allSeries = snapshot.data ?? [];
                      final filtered = searchKey.isEmpty
                          ? allSeries
                          : allSeries
                              .where((s) => (s.name ?? "")
                                  .toLowerCase()
                                  .contains(searchKey))
                              .toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Text(
                            "لا توجد مسلسلات في هذه الباقة",
                            style: styleBody.copyWith(fontSize: 13),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 145,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final model = filtered[i];
                          return CardMovieItem(
                            image: model.cover ?? "",
                            name: model.name ?? "",
                            rate: double.tryParse(model.rating5based ?? "0") ?? 0.0,
                            onTap: () {
                              router.pushNamed(
                                screenSerieDetails,
                                extra: model,
                                queryParameters: {
                                  "channel_name": _selectedCategoryName,
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
