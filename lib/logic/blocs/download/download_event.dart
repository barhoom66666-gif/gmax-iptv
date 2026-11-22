part of 'download_bloc.dart';

@immutable
abstract class DownloadEvent {}

class DownloadAllCategoriesEvent extends DownloadEvent {}

class DownloadMoviesEvent extends DownloadEvent {
  final bool forceAll;

  DownloadMoviesEvent({this.forceAll = true});
}

class DownloadLivesEvent extends DownloadEvent {
  final bool forceAll;

  DownloadLivesEvent({this.forceAll = true});
}

class DownloadSeriesEvent extends DownloadEvent {}

class DownloadAllDataEvent extends DownloadEvent {}
