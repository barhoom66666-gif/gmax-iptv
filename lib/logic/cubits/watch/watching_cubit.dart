import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/api/api.dart';
import '../../../repository/models/watching.dart';

part 'watching_state.dart';

class WatchingCubit extends Cubit<WatchingState> {
  final WatchingLocale favoriteLocale;

  WatchingCubit(this.favoriteLocale) : super(WatchingState.defaultData());

  void initialData() async {
    emit(WatchingState(
      videos: await favoriteLocale.getWatchingMovies(),
    ));
  }

  void addMovie(WatchingModel movie) async {
    final List<WatchingModel> editList = state.videos
        .where((element) => element.streamId != movie.streamId)
        .toList();
    editList.insert(0, movie);

    await favoriteLocale.saveWatchingMovie(editList);
    emit(WatchingState(videos: editList));
  }

  void clearData() async {
    await favoriteLocale.deleteWatching();
    emit(WatchingState.defaultData());
  }
}
