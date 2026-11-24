part of '../api/api.dart';

class FavoriteLocale {
  Future<bool> saveFavoriteMovie(ChannelMovie movie, bool isLike) async {
    try {
      final user = await AuthLocale.getUser();
      final acc = user?.accountName ?? "default";
      final sid = movie.streamId ?? "";

      await _sqlDb.deleteData(
        "DELETE FROM '$tableChannels' WHERE stream_type = 'movie' AND stream_id = '$sid'",
      );

      if (isLike) {
        final Map<String, dynamic> map = movie.toJson();
        map['account_name'] = acc;
        map['stream_type'] = 'movie';
        map['is_favourite'] = 1;
        await _sqlDb.insertMapData(tableChannels, map);
      }
      return true;
    } catch (e) {
      debugPrint("Error saveFavoriteMovie: $e");
      return false;
    }
  }

  Future<bool> saveFavoriteSerie(ChannelSerie serie, bool isLike) async {
    try {
      final user = await AuthLocale.getUser();
      final acc = user?.accountName ?? "default";
      final sid = serie.seriesId ?? "";

      await _sqlDb.deleteData(
        "DELETE FROM '$tableChannels' WHERE stream_type = 'serie' AND series_id = '$sid'",
      );

      if (isLike) {
        final Map<String, dynamic> map = serie.toJson();
        map['account_name'] = acc;
        map['stream_type'] = 'serie';
        map['is_favourite'] = 1;
        await _sqlDb.insertMapData(tableChannels, map);
      }
      return true;
    } catch (e) {
      debugPrint("Error saveFavoriteSerie: $e");
      return false;
    }
  }

  Future<bool> saveFavoriteLiveModel(ChannelLive live, bool isLike) async {
    try {
      final user = await AuthLocale.getUser();
      final acc = user?.accountName ?? "default";
      final sid = live.streamId ?? "";

      await _sqlDb.deleteData(
        "DELETE FROM '$tableChannelLives' WHERE stream_id = '$sid'",
      );

      if (isLike) {
        final Map<String, dynamic> map = live.toJson();
        map['account_name'] = acc;
        map['is_favourite'] = 1;
        await _sqlDb.insertMapData(tableChannelLives, map);
      }
      return true;
    } catch (e) {
      debugPrint("Error saveFavoriteLiveModel: $e");
      return false;
    }
  }

  Future<List<ChannelMovie>> getFavMovies({int? page, int? pageSize}) async {
    try {
      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);
      final database = await _sqlDb.readDataQuery(
        tableChannels,
        offset: offset,
        limit: pageSize,
        where: "stream_type = ? AND is_favourite = ?",
        whereArgs: ["movie", 1],
      );
      return database.map((e) => ChannelMovie.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error Fav movies: $e");
      return [];
    }
  }

  Future<List<ChannelSerie>> getFavSeries({int? page, int? pageSize}) async {
    try {
      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);
      final database = await _sqlDb.readDataQuery(
        tableChannels,
        limit: pageSize,
        offset: offset,
        where: "stream_type = ? AND is_favourite = ?",
        whereArgs: ["serie", 1],
      );
      return database.map((e) => ChannelSerie.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error Fav Series: $e");
      return [];
    }
  }

  Future<List<ChannelLive>> getFavLives({int? page, int? pageSize}) async {
    try {
      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);
      final database = await _sqlDb.readDataQuery(
        tableChannelLives,
        limit: pageSize,
        offset: offset,
        where: "is_favourite = ?",
        whereArgs: [1],
      );
      return database.map((e) => ChannelLive.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error get Fav Live: $e");
      return [];
    }
  }
}

class WatchingLocale {
  Future<bool> saveWatchingMovie(List<WatchingModel> movies) async => true;
  Future<bool> saveWatchSerie(List<WatchingModel> series) async => true;
  Future<bool> saveWatchLive(List<WatchingModel> series) async => true;
  Future<List<WatchingModel>> getWatchingMovies() async => [];
  Future<List<WatchingModel>> getWatchingSeries() async => [];
  Future<List<WatchingModel>> getWatchingLives() async => [];
  Future<void> deleteWatching() async {}
}
