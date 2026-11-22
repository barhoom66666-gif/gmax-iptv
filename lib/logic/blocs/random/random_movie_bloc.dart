import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../repository/api/api.dart';
import '../../../repository/models/channel_movie.dart';

part 'random_movie_event.dart';

part 'random_movie_state.dart';

class RandomMovieBloc extends Bloc<RandomMovieEvent, RandomMovieState> {
  RandomMovieBloc() : super(RandomMovieInitial()) {
    on<GetRandomMovie>((event, emit) async {
      try {
        final List<ChannelMovie> movies =
            await MoviesLocale.getAllMovies(pageSize: 1, page: 1);

        if (movies.isNotEmpty) {
          emit(RandomMovieSuccess(
            movie: movies.first,
            channelName: "",
          ));
        } else {
          debugPrint("Random is Empty");
        }
      } catch (e) {
        debugPrint("Random Error: $e");
      }
    });
  }
}
