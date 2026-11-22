part of '../api/api.dart';

class FavoriteLocale {
  Future<bool> addChannelToFav(String channelId, bool isLike) async {
    try {
      var response = await _sqlDb.deleteData(
          "UPDATE '$tableChannels' SET 'is_favourite' = '${isLike ? 1 : 0}' WHERE id = $channelId");

      debugPrint("Fav $channelId RES: $response");

      return true;
    } catch (e) {
      debugPrint("Error: Fav Movie: $e");
      return true;
    }
  }

  Future<bool> saveFavoriteLive(String liveId, bool isLike) async {
    try {
      var response = await _sqlDb.deleteData(
          "UPDATE '$tableChannelLives' SET 'is_favourite' = '${isLike ? 1 : 0}' WHERE id = $liveId");

      debugPrint("Fav $liveId RES: $response");

      return true;
    } catch (e) {
      debugPrint("Error: Fav lives: $e");
      return true;
    }
  }

  Future<List<ChannelMovie>> getFavMovies({int? page, int? pageSize}) async {
    try {
      final user = await AuthLocale.getUser();

      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);

      final database = await _sqlDb.readDataQuery(
        tableChannels,
        offset: offset,
        limit: pageSize,
        where: "stream_type = ? AND account_name = ? AND is_favourite = ?",
        whereArgs: ["movie", user!.accountName, 1],
      );

      return database.map((e) => ChannelMovie.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error Fav movies: $e");
      return [];
    }
  }

  Future<List<ChannelSerie>> getFavSeries({int? page, int? pageSize}) async {
    try {
      final user = await AuthLocale.getUser();

      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);

      final database = await _sqlDb.readDataQuery(
        tableChannels,
        limit: pageSize,
        offset: offset,
        where: "stream_type = ? AND account_name = ? AND is_favourite = ?",
        whereArgs: ["serie", user!.accountName, 1],
      );

      return database.map((e) => ChannelSerie.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error Fav Series: $e");
      return [];
    }
  }

  Future<List<ChannelLive>> getFavLives({int? page, int? pageSize}) async {
    try {
      final user = await AuthLocale.getUser();

      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);

      final database = await _sqlDb.readDataQuery(
        tableChannelLives,
        limit: pageSize,
        offset: offset,
        where: "account_name = ? AND is_favourite = ?",
        whereArgs: [user!.accountName, 1],
      );
      return database.map((e) => ChannelLive.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error get Fav Live: $e");
      return [];
    }
  }
}

class WatchingLocale {
  Future<bool> saveWatchingMovie(List<WatchingModel> movies) async {
    try {
      final user = await AuthLocale.getUser();
      if (user == null) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("Error: watch Movie: $e");
      return true;
    }
  }

  Future<bool> saveWatchSerie(List<WatchingModel> series) async {
    try {
      final user = await AuthLocale.getUser();
      if (user == null) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("Error: watch Series: $e");
      return true;
    }
  }

  Future<bool> saveWatchLive(List<WatchingModel> series) async {
    try {
      final user = await AuthLocale.getUser();
      if (user == null) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("Error: watch Live: $e");
      return true;
    }
  }

  Future<List<WatchingModel>> getWatchingMovies() async {
    try {
      final user = await AuthLocale.getUser();
      if (user == null) {
        return [];
      }

      return [];
    } catch (e) {
      debugPrint("Error: Getwatch Movie: $e");
      return [];
    }
  }

  Future<List<WatchingModel>> getWatchingSeries() async {
    try {
      final user = await AuthLocale.getUser();
      if (user == null) {
        return [];
      }

      return [];
    } catch (e) {
      debugPrint("Error: Getwatch Series: $e");
      return [];
    }
  }

  Future<List<WatchingModel>> getWatchingLives() async {
    try {
      final user = await AuthLocale.getUser();
      if (user == null) {
        return [];
      }

      return [];
    } catch (e) {
      debugPrint("Error: Getwatch Live: $e");
      return [];
    }
  }

  Future<void> deleteWatching() async {
    final user = await AuthLocale.getUser();
    if (user == null) {
      return;
    }
  }
}
