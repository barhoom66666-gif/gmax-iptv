part of 'watching_cubit.dart';

/*@immutable
abstract class WatchingState {}*/

class WatchingState {
  final List<WatchingModel> videos;

  WatchingState({
    required this.videos,
  });

  factory WatchingState.defaultData() {
    return WatchingState(
      videos: const [],
    );
  }
}
