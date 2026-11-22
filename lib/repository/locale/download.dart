part of '../api/api.dart';

class ChannelsLocale {
  ///Channels
  static Future<bool> saveChannels(
      List<CategoryModel> list, String type) async {
    try {
      final user = await AuthLocale.getUser();

      //TODO: save Categories to sql database
      for (var caty in list) {
        //check if item exist
        final List<Map> existingRecord = await _sqlDb.readDataQuery(
          tableCategories,
          where: 'category_id = ? AND account_name = ?',
          whereArgs: [caty.categoryId, user!.accountName],
        );

        if (existingRecord.isEmpty) {
          Map<String, dynamic> mapCaty = caty.toJson();
          mapCaty['account_name'] = user.accountName;
          mapCaty['type'] = type;

          //create one
          int res = await _sqlDb.insertMapData(
            tableCategories,
            mapCaty,
          );
          debugPrint(
              "CHANNEL POST: ${user.accountName} || ${caty.categoryName} || RES:$res");
        } else {
          //update or ignore
          debugPrint(
              "CHANNEL Exist: ${user.accountName} || ${caty.categoryName} || ${existingRecord.first['id']}");
          // final model = existingRecord.first;
        }
      }

      return true;
    } catch (e) {
      debugPrint("Error save channels $type: $e");
      return false;
    }
  }

  static Future<List<CategoryModel>> getChannels(
    String type, {
    int? pageSize,
    int? page,
  }) async {
    try {
      final user = await AuthLocale.getUser();

      //TODO get Categories from SQLDb

      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);

      final database = await _sqlDb.readDataQuery(
        tableCategories,
        where: "type = ? AND account_name = ?",
        offset: offset,
        limit: pageSize,
        whereArgs: [type, user!.accountName],
      );

      return database.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error get channels $type: $e");
      return [];
    }
  }

  static Future<bool> deleteChannels(String type, String accountName) async {
    try {
      //TODO: delete channels

      return true;
    } catch (e) {
      debugPrint("$type: $e");
      return true;
    }
  }
}

class MoviesLocale {
  Future<bool> saveMoviesByCaty(ChannelMovie caty) async {
    try {
      final user = await AuthLocale.getUser();

      //check if item exist
      final List<Map> existingRecord = await _sqlDb.readDataQuery(
        tableChannels,
        where: 'stream_type = ? AND stream_id = ? AND account_name = ?',
        whereArgs: ["movie", caty.streamId, user!.accountName],
      );

      if (existingRecord.isEmpty) {
        Map<String, dynamic> mapCaty = caty.toJson();
        mapCaty['account_name'] = user.accountName;
        mapCaty['stream_type'] = "movie";

        //create one
        int res = await _sqlDb.insertMapData(
          tableChannels,
          mapCaty,
        );
        debugPrint(
            "MOVIE POST: ${user.accountName} || ${caty.name} || RES:$res");
      } else {
        //update or ignore
        debugPrint(
            "MOVIE Exist: ${user.accountName} || ${caty.name} || ${existingRecord.first['id']}");
        // final model = existingRecord.first;
      }

      return true;
    } catch (e) {
      debugPrint("Error save movies: $e");
      return false;
    }
  }

  static Future<List<ChannelMovie>> getMoviesByCaty(String catyId,
      {int? page, int? pageSize}) async {
    try {
      final user = await AuthLocale.getUser();

      //TODO: get Movies by caty
      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);

      final database = await _sqlDb.readDataQuery(
        tableChannels,
        offset: offset,
        limit: pageSize,
        where: "stream_type = ? AND account_name = ? AND category_id = ?",
        whereArgs: ["movie", user!.accountName, catyId],
      );

      // debugPrint("MOVIES: $catyId ${database.length}");

      return database.map((e) => ChannelMovie.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error movies by $catyId: $e");
      return [];
    }
  }

  static Future<List<ChannelMovie>> getAllMovies(
      {int? page, int? pageSize}) async {
    try {
      final user = await AuthLocale.getUser();

      //TODO: get Movies by caty
      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);

      final database = await _sqlDb.readDataQuery(
        tableChannels,
        offset: offset,
        limit: pageSize,
        where: "stream_type = ? AND account_name = ?",
        whereArgs: ["movie", user!.accountName],
      );

      return database.map((e) => ChannelMovie.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error all movies: $e");
      return [];
    }
  }

  static Future<bool> deleteMovies(String catyId, String accountName) async {
    try {
      //TODO: delete Movies

      return true;
    } catch (e) {
      debugPrint("Error get channels $catyId: $e");
      return true;
    }
  }
}

class LiveLocale {
  Future<bool> saveLiveByCaty(ChannelLive caty) async {
    try {
      final user = await AuthLocale.getUser();

      //TODO Save Lives to SqlDb

      //check if item exist
      final List<Map> existingRecord = await _sqlDb.readDataQuery(
        tableChannelLives,
        where: 'stream_id = ? AND account_name = ?',
        whereArgs: [caty.streamId, user!.accountName],
      );

      if (existingRecord.isEmpty) {
        Map<String, dynamic> mapCaty = caty.toJson();
        mapCaty['account_name'] = user.accountName;

        //create one
        int res = await _sqlDb.insertMapData(
          tableChannelLives,
          mapCaty,
        );
        debugPrint("Created: ${user.accountName} || ${caty.name} || RES:$res");
      } else {
        //update or ignore
        debugPrint(
            "Exist: ${user.accountName} || ${caty.name} || ${existingRecord.first['id']}");
        // final model = existingRecord.first;
      }

      return true;
    } catch (e) {
      debugPrint("Error save live: $e");
      return false;
    }
  }

  static Future<List<ChannelLive>> getLiveById(String catyId,
      {int? page, int? pageSize}) async {
    try {
      final user = await AuthLocale.getUser();

      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);

      final database = await _sqlDb.readDataQuery(
        tableChannelLives,
        limit: pageSize,
        offset: offset,
        where: "account_name = ? AND category_id = ?",
        whereArgs: [user!.accountName, catyId],
      );
      return database.map((e) => ChannelLive.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error Live by $catyId: $e");
      return [];
    }
  }

  Future<List<CategoryModel>> getChannelsLives() async {
    try {
      final user = await AuthLocale.getUser();

      //TODO: Get Channels
      // final offset = (page - 1) * pageSize;

      final database = await _sqlDb.readDataQuery(
        tableCategories,
        where: "type = ? AND account_name = ?",
        whereArgs: ["lives", user!.accountName],
      );

      return database.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error get channels lives: $e");
      return [];
    }
  }

  static Future<bool> deleteLives(String catyId) async {
    try {
      final user = await AuthLocale.getUser();

      if (user == null) {
        return false;
      }

      //TODO: delete Lives

      return true;
    } catch (e) {
      debugPrint("Error get channels $catyId: $e");
      return true;
    }
  }
}

class TvSHowsLocale {
  Future<bool> saveTvSHowByCaty(ChannelSerie caty) async {
    try {
      final user = await AuthLocale.getUser();

      //TODO: Save Series to Sqldb

      //check if item exist
      final List<Map> existingRecord = await _sqlDb.readDataQuery(
        tableChannels,
        where: 'stream_type = ? AND series_id = ? AND account_name = ?',
        whereArgs: ["serie", caty.seriesId, user!.accountName],
      );

      if (existingRecord.isEmpty) {
        Map<String, dynamic> mapCaty = caty.toJson();
        mapCaty['account_name'] = user.accountName;
        mapCaty['stream_type'] = "serie";

        //create one
        int res = await _sqlDb.insertMapData(
          tableChannels,
          mapCaty,
        );
        debugPrint("Created: ${user.accountName} || ${caty.name} || RES:$res");
      } else {
        //update or ignore
        debugPrint(
            "Exist: ${user.accountName} || ${caty.name} || ${existingRecord.first['id']}");
        // final model = existingRecord.first;
      }

      return true;
    } catch (e) {
      debugPrint("Error save TvShow: $e");
      return false;
    }
  }

  static Future<List<ChannelSerie>> getTvSHowsByCaty(String catyId,
      {int? page, int? pageSize}) async {
    try {
      final user = await AuthLocale.getUser();

      //TODO: get Series from Sqldb

      final offset = page == null ? null : (page - 1) * (pageSize ?? 10);

      final database = await _sqlDb.readDataQuery(
        tableChannels,
        limit: pageSize,
        offset: offset,
        where: "stream_type = ? AND account_name = ? AND category_id = ?",
        whereArgs: ["serie", user!.accountName, catyId],
      );

      return database.map((e) => ChannelSerie.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error tv show by $catyId: $e");
      return [];
    }
  }

  static Future<bool> deleteSerie(String catyId, String accountName) async {
    try {
      //TODO: delete series

      return true;
    } catch (e) {
      debugPrint("Error  $catyId: $e");
      return true;
    }
  }
}
