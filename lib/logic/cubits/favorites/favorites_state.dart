part of 'favorites_cubit.dart';

/*@immutable
abstract class FavoritesState {}*/

class FavoritesState {
  final List<ChannelMovie> movies;
  final List<ChannelSerie> series;
  final List<ChannelLive> lives;

  FavoritesState(
      {required this.movies, required this.series, required this.lives});

  factory FavoritesState.defaultData() {
    return FavoritesState(
      series: const [],
      movies: const [],
      lives: const [],
    );
  }

  FavoritesState copyWith({
    final List<ChannelMovie>? movies,
    final List<ChannelSerie>? series,
    final List<ChannelLive>? lives,
  }) {
    return FavoritesState(
      movies: movies ?? this.movies,
      series: series ?? this.series,
      lives: lives ?? this.lives,
    );
  }
}
