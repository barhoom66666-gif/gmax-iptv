part of 'random_movie_bloc.dart';

@immutable
abstract class RandomMovieState {}

class RandomMovieInitial extends RandomMovieState {}

class RandomMovieLoading extends RandomMovieState {}

class RandomMovieSuccess extends RandomMovieState {
  final ChannelMovie movie;
  final String channelName;

  RandomMovieSuccess({required this.movie, required this.channelName});
}
