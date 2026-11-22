part of 'search_cubit.dart';

class SearchState {
  final String searchKey;
  final int page;
  final bool showSearch;

  SearchState(
      {required this.searchKey, required this.page, required this.showSearch});

  SearchState copyWith({
    final String? searchKey,
    final int? page,
    final bool? showSearch,
  }) {
    return SearchState(
      searchKey: searchKey ?? this.searchKey,
      page: page ?? this.page,
      showSearch: showSearch ?? this.showSearch,
    );
  }
}
