import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../helpers/helpers.dart';
import '../../../repository/api/api.dart';

part 'download_event.dart';

part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final MoviesLocale moviesLocale;
  final LiveLocale liveLocale;
  final TvSHowsLocale seriesLocale;

  // final SearchLocale searchLocale;
  final IpTvApi api;

  DownloadBloc(
      {required this.moviesLocale,
      required this.liveLocale,
      required this.seriesLocale,
      //  required this.searchLocale,
      required this.api})
      : super(DownloadInitial()) {
    on<DownloadAllCategoriesEvent>((event, emit) async {
      //
      add(DownloadLivesEvent(forceAll: true));
    });

    //Lives
    on<DownloadLivesEvent>(
      (event, emit) async {
        emit(DownloadLoading(label: "Download live"));

        ///Lives
        final localeCategories = await api.getCategories("get_live_categories");
        await ChannelsLocale.saveChannels(localeCategories, "lives");

        final channelsLive = await api.getLiveChannels();

        for (int i = 0; i < (kIsDebugTest ? 10 : channelsLive.length); i++) {
          emit(DownloadLoading(
              label: "Download live",
              total: channelsLive.length,
              progress: i + 1));

          await liveLocale.saveLiveByCaty(channelsLive[i]);
        }

        if (event.forceAll) {
          add(DownloadMoviesEvent(forceAll: true));
        } else {
          emit(DownloadFinish());
        }
      },
    );

    //Movies
    on<DownloadMoviesEvent>(
      (event, emit) async {
        emit(DownloadLoading(label: "Download Movie"));

        final localeCategories = await api.getCategories("get_vod_categories");
        await ChannelsLocale.saveChannels(localeCategories, "movies");

        debugPrint("CHANNELS MOVIES SAVED");

        final channelsMovies = await api.getMovieChannels();

        debugPrint("SIZE MOVIES: ${channelsMovies.length}");

        for (int i = 0; i < (kIsDebugTest ? 10 : channelsMovies.length); i++) {
          emit(
            DownloadLoading(
                label: "Download Movie",
                total: channelsMovies.length,
                progress: i + 1),
          );

          await moviesLocale.saveMoviesByCaty(channelsMovies[i]);
        }
        if (event.forceAll) {
          add(DownloadSeriesEvent());
        } else {
          emit(DownloadFinish());
        }
      },
    );

    //Series
    on<DownloadSeriesEvent>(
      (event, emit) async {
        emit(DownloadLoading(label: "Download Series"));

        final localeCategories =
            await api.getCategories("get_series_categories");
        await ChannelsLocale.saveChannels(localeCategories, "series");

        final channelsSeries = await api.getSeriesChannels();

        for (int i = 0; i < (kIsDebugTest ? 10 : channelsSeries.length); i++) {
          emit(DownloadLoading(
              label: "Download Series",
              total: channelsSeries.length,
              progress: i + 1));

          await seriesLocale.saveTvSHowByCaty(channelsSeries[i]);
        }

        //  add(DownloadAllDataEvent());
        emit(DownloadFinish());
      },
    );
  }
}
