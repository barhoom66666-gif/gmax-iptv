import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/api/api.dart';
import '../../../repository/models/category.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesState(const [], const [], const []));

  initialCategories() async {
    final lives = await ChannelsLocale.getChannels("lives");
    final movies = await ChannelsLocale.getChannels("movies");
    final series = await ChannelsLocale.getChannels("series");
    emit(CategoriesState(lives, movies, series));
  }
}
