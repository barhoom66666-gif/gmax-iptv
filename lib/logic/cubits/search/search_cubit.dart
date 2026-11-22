import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit()
      : super(SearchState(
          page: 0,
          searchKey: "",
          showSearch: false,
        ));

  void addSearch(String? search, int? page, bool showSearch) {
    emit(state.copyWith(showSearch: showSearch, page: page, searchKey: search));
  }
}
