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

  final IpTvApi api;

  DownloadBloc({
    required this.moviesLocale,
    required this.liveLocale,
    required this.seriesLocale,
    required this.api,
  }) : super(DownloadInitial()) {
    on<DownloadAllCategoriesEvent>((event, emit) async {
      IpTvApi.clearMemoryCaches();
      add(DownloadLivesEvent(forceAll: true));
    });

    // Lives
    on<DownloadLivesEvent>(
      (event, emit) async {
        emit(DownloadLoading(label: "جارٍ تحميل باقات البث المباشر..."));

        final localeCategories = await api.getCategories("get_live_categories");
        await ChannelsLocale.saveChannels(localeCategories, "lives");

        final user = await AuthLocale.getUser();
        if (user != null && user.domain == "https://demo.gmax.iptv") {
          final channelsLive = await api.getLiveChannels();
          for (int i = 0; i < channelsLive.length; i++) {
            emit(DownloadLoading(
                label: "Download live",
                total: channelsLive.length,
                progress: i + 1));
            await liveLocale.saveLiveByCaty(channelsLive[i]);
          }
        } else {
          emit(DownloadLoading(
              label: "تم تحميل باقات البث المباشر",
              total: localeCategories.length,
              progress: localeCategories.length));
        }

        if (event.forceAll) {
          add(DownloadMoviesEvent(forceAll: true));
        } else {
          emit(DownloadFinish());
        }
      },
    );

    // Movies
    on<DownloadMoviesEvent>(
      (event, emit) async {
        emit(DownloadLoading(label: "جارٍ تحميل باقات الأفلام..."));

        final localeCategories = await api.getCategories("get_vod_categories");
        await ChannelsLocale.saveChannels(localeCategories, "movies");

        final user = await AuthLocale.getUser();
        if (user != null && user.domain == "https://demo.gmax.iptv") {
          final channelsMovies = await api.getMovieChannels();
          for (int i = 0; i < channelsMovies.length; i++) {
            emit(
              DownloadLoading(
                  label: "Download Movie",
                  total: channelsMovies.length,
                  progress: i + 1),
            );
            await moviesLocale.saveMoviesByCaty(channelsMovies[i]);
          }
        } else {
          emit(DownloadLoading(
              label: "تم تحميل باقات الأفلام",
              total: localeCategories.length,
              progress: localeCategories.length));
        }

        if (event.forceAll) {
          add(DownloadSeriesEvent());
        } else {
          emit(DownloadFinish());
        }
      },
    );

    // Series
    on<DownloadSeriesEvent>(
      (event, emit) async {
        emit(DownloadLoading(label: "جارٍ تحميل باقات المسلسلات..."));

        final localeCategories =
            await api.getCategories("get_series_categories");
        await ChannelsLocale.saveChannels(localeCategories, "series");

        final user = await AuthLocale.getUser();
        if (user != null && user.domain == "https://demo.gmax.iptv") {
          final channelsSeries = await api.getSeriesChannels();
          for (int i = 0; i < channelsSeries.length; i++) {
            emit(DownloadLoading(
                label: "Download Series",
                total: channelsSeries.length,
                progress: i + 1));
            await seriesLocale.saveTvSHowByCaty(channelsSeries[i]);
          }
        } else {
          emit(DownloadLoading(
              label: "تم تحميل باقات المسلسلات",
              total: localeCategories.length,
              progress: localeCategories.length));
        }

        emit(DownloadFinish());
      },
    );
  }
}
