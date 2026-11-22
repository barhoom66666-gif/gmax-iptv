import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../repository/api/api.dart';
import '../../../repository/models/channel_live.dart';
import '../../../repository/models/channel_movie.dart';
import '../../../repository/models/channel_serie.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteLocale favoriteLocale;

  FavoritesCubit(this.favoriteLocale) : super(FavoritesState.defaultData());

  void initialData() async {
    emit(FavoritesState(
      series: await favoriteLocale.getFavSeries(),
      movies: await favoriteLocale.getFavMovies(),
      lives: await favoriteLocale.getFavLives(),
    ));
  }

  void addMovie(ChannelMovie model, {required bool isAdd}) async {
    await favoriteLocale.addChannelToFav(model.id!, isAdd);

    emit(state.copyWith(movies: await favoriteLocale.getFavMovies()));
  }

  void addSerie(ChannelSerie model, {required bool isAdd}) async {
    await favoriteLocale.addChannelToFav(model.id!, isAdd);
    final list = await favoriteLocale.getFavSeries();
    debugPrint("FAV SIZE: ${list.length}");
    emit(state.copyWith(series: list));
  }

  void addLive(ChannelLive model, {required bool isAdd}) async {
    await favoriteLocale.saveFavoriteLive(model.id!, isAdd);
    emit(state.copyWith(lives: await favoriteLocale.getFavLives()));
  }
}
