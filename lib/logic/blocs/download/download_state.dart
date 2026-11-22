part of 'download_bloc.dart';

@immutable
abstract class DownloadState {}

class DownloadInitial extends DownloadState {}

class DownloadLoading extends DownloadState {
  final int? total;
  final int? progress;
  final String label;

  DownloadLoading({this.total, this.progress, required this.label});
}

class DownloadFinish extends DownloadState {}
