import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/api/api.dart';
import '../../../repository/models/category.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesState(const [], const [], const []));

  initialCategories() async {
    var lives = await ChannelsLocale.getChannels("lives");
    var movies = await ChannelsLocale.getChannels("movies");
    var series = await ChannelsLocale.getChannels("series");

    if (lives.isEmpty && movies.isEmpty && series.isEmpty) {
      final api = IpTvApi();
      lives = await api.getCategories("get_live_categories");
      if (lives.isNotEmpty) await ChannelsLocale.saveChannels(lives, "lives");
      movies = await api.getCategories("get_vod_categories");
      if (movies.isNotEmpty) await ChannelsLocale.saveChannels(movies, "movies");
      series = await api.getCategories("get_series_categories");
      if (series.isNotEmpty) await ChannelsLocale.saveChannels(series, "series");
    }

    emit(CategoriesState(lives, movies, series));
  }
}
