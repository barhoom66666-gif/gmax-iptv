part of 'api.dart';

class IpTvApi {
  /// Categories
  Future<List<CategoryModel>> getCategories(String type) async {
    try {
      final user = await AuthLocale.getUser();

      if (user == null) {
        debugPrint("User is Null");
        return [];
      }

      if (user.domain == "https://demo.gmax.iptv") {
        if (type == "get_live_categories") {
          return [
            CategoryModel(categoryId: "1", categoryName: "Arabic & Global News", parentId: 0),
            CategoryModel(categoryId: "2", categoryName: "Sports & Science", parentId: 0),
          ];
        } else if (type == "get_vod_categories") {
          return [
            CategoryModel(categoryId: "10", categoryName: "Action & Sci-Fi", parentId: 0),
            CategoryModel(categoryId: "11", categoryName: "Animation & Cinema", parentId: 0),
          ];
        } else {
          return [
            CategoryModel(categoryId: "20", categoryName: "Featured Series", parentId: 0),
          ];
        }
      }

      debugPrint("server: ${user.domain}");

      var url = "${user.domain}/player_api.php";

      Response<String> response = await _dio.get(
        url,
        queryParameters: {
          "password": user.userInfo!.password,
          "username": user.userInfo!.username,
          "action": type,
        },
        options: _options,
      );

      debugPrint("URL: ${response.realUri}");

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.data ?? "[]");

        final list = json.map((e) => CategoryModel.fromJson(e)).toList();
        //  save list to locale

        return list;
      } else {
        debugPrint("Can't get $type: ${response.statusCode}");
        showWarningToast(
            "The requested server could not be reached and is returning a 404 error.");
      }

      return [];
    } on DioException catch (e) {
      debugPrint("Error getCategories $type: $e");
      return [];
    } catch (e) {
      debugPrint("Error getCategories $type: $e");
      return [];
    }
  }

  /// Channels Live
  Future<List<ChannelLive>> getLiveChannels() async {
    try {
      final user = await AuthLocale.getUser();
      if (user != null && user.domain == "https://demo.gmax.iptv") {
        return [
          ChannelLive.fromJson({
            "num": 1,
            "name": "Al Jazeera Arabic HD",
            "stream_type": "live",
            "stream_id": 101,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/en/thumb/f/f2/Aljazeera_eng.svg/320px-Aljazeera_eng.svg.png",
            "category_id": "1",
            "direct_source": "https://live-hls-web-aja.getaj.net/AJA/index.m3u8"
          }),
          ChannelLive.fromJson({
            "num": 2,
            "name": "Al Jazeera Mubasher HD",
            "stream_type": "live",
            "stream_id": 102,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/en/thumb/f/f2/Aljazeera_eng.svg/320px-Aljazeera_eng.svg.png",
            "category_id": "1",
            "direct_source": "https://live-hls-web-ajm.getaj.net/AJM/index.m3u8"
          }),
          ChannelLive.fromJson({
            "num": 3,
            "name": "Al Jazeera English HD",
            "stream_type": "live",
            "stream_id": 103,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/en/thumb/f/f2/Aljazeera_eng.svg/320px-Aljazeera_eng.svg.png",
            "category_id": "1",
            "direct_source": "https://live-hls-web-aje.getaj.net/AJE/index.m3u8"
          }),
          ChannelLive.fromJson({
            "num": 4,
            "name": "DW Live Global",
            "stream_type": "live",
            "stream_id": 104,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Deutsche_Welle_symbol_2012.svg/320px-Deutsche_Welle_symbol_2012.svg.png",
            "category_id": "1",
            "direct_source": "https://dwamdstream103.akamaized.net/hls/live/2015526/dwstream103/index.m3u8"
          }),
          ChannelLive.fromJson({
            "num": 5,
            "name": "Red Bull TV Sports HD",
            "stream_type": "live",
            "stream_id": 201,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/en/thumb/f/f5/RedBull_TV_logo.svg/320px-RedBull_TV_logo.svg.png",
            "category_id": "2",
            "direct_source": "https://rbmn-live.akamaized.net/hls/live/590964/BoRB-AT/master.m3u8"
          }),
          ChannelLive.fromJson({
            "num": 6,
            "name": "NASA TV Public HD",
            "stream_type": "live",
            "stream_id": 202,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/NASA_logo.svg/320px-NASA_logo.svg.png",
            "category_id": "2",
            "direct_source": "https://ntv1.akamaized.net/hls/live/2014075/NASA-NTV1-HLS/master.m3u8"
          }),
        ];
      }

      var url = "${user!.domain}/player_api.php";

      Response<String> response = await _dio.get(
        url,
        queryParameters: {
          "password": user.userInfo!.password,
          "username": user.userInfo!.username,
          "action": "get_live_streams",
          // "category_id": catyId
        },
        options: _options,
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.data ?? "[]");

        final list = json.map((e) => ChannelLive.fromJson(e)).toList();
        //  save list to locale

        return list;
      } else {
        debugPrint("Error: ${response.statusCode}");
        showWarningToast(
            "The requested server could not be reached and is returning a 404 error.");
      }

      return [];
    } catch (e) {
      debugPrint("Error Channel : $e");
      return [];
    }
  }

  /// Channels Movie
  Future<List<ChannelMovie>> getMovieChannels() async {
    try {
      final user = await AuthLocale.getUser();
      if (user != null && user.domain == "https://demo.gmax.iptv") {
        return [
          ChannelMovie.fromJson({
            "num": 1,
            "name": "Tears of Steel (4K Sci-Fi)",
            "stream_type": "movie",
            "stream_id": 301,
            "stream_icon": "https://m.media-amazon.com/images/M/MV5BMTg0NjEwNjUxM15BMl5BanBnXkFtZTcwMzk0MjQ5Mg@@._V1_.jpg",
            "rating": "8.6",
            "rating_5based": 4.3,
            "category_id": "10",
            "container_extension": "mp4",
            "direct_source": "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"
          }),
          ChannelMovie.fromJson({
            "num": 2,
            "name": "Sintel — Dragon Fantasy",
            "stream_type": "movie",
            "stream_id": 302,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Sintel_poster.jpg/400px-Sintel_poster.jpg",
            "rating": "8.9",
            "rating_5based": 4.5,
            "category_id": "11",
            "container_extension": "mp4",
            "direct_source": "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
          }),
          ChannelMovie.fromJson({
            "num": 3,
            "name": "Big Buck Bunny HD",
            "stream_type": "movie",
            "stream_id": 303,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Big_buck_bunny_poster_big.jpg/400px-Big_buck_bunny_poster_big.jpg",
            "rating": "8.2",
            "rating_5based": 4.1,
            "category_id": "11",
            "container_extension": "mp4",
            "direct_source": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
          }),
          ChannelMovie.fromJson({
            "num": 4,
            "name": "Elephants Dream",
            "stream_type": "movie",
            "stream_id": 304,
            "stream_icon": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/ElephantsDreamPoster.jpg/400px-ElephantsDreamPoster.jpg",
            "rating": "7.9",
            "rating_5based": 4.0,
            "category_id": "10",
            "container_extension": "mp4",
            "direct_source": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
          }),
        ];
      }

      var url = "${user!.domain}/player_api.php";

      Response<String> response = await _dio.get(
        url,
        queryParameters: {
          "password": user.userInfo!.password,
          "username": user.userInfo!.username,
          "action": "get_vod_streams",
          //   "category_id": catyId
        },
        options: _options,
      );

      debugPrint("URL: ${response.realUri}");

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.data ?? "[]");

        final list = json.map((e) => ChannelMovie.fromJson(e)).toList();
        //  save list to locale

        return list;
      } else {
        debugPrint("Error: ${response.statusCode}");
        showWarningToast(
            "The requested server could not be reached and is returning a 404 error.");
      }

      return [];
    } catch (e) {
      debugPrint("Error Channel : $e");
      return [];
    }
  }

  /// Channels Series
  Future<List<ChannelSerie>> getSeriesChannels() async {
    try {
      final user = await AuthLocale.getUser();
      if (user != null && user.domain == "https://demo.gmax.iptv") {
        return [
          ChannelSerie.fromJson({
            "num": 1,
            "name": "Cyber Chronicles S01",
            "series_id": 401,
            "cover": "https://m.media-amazon.com/images/M/MV5BMTg0NjEwNjUxM15BMl5BanBnXkFtZTcwMzk0MjQ5Mg@@._V1_.jpg",
            "plot": "Sci-Fi Adventure Series",
            "rating": "9.0",
            "rating_5based": 4.5,
            "category_id": "20"
          }),
        ];
      }

      var url = "${user!.domain}/player_api.php";

      Response<String> response = await _dio.get(
        url,
        queryParameters: {
          "password": user.userInfo!.password,
          "username": user.userInfo!.username,
          "action": "get_series",
          // "category_id": catyId
        },
        options: _options,
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.data ?? "[]");

        final list = json.map((e) => ChannelSerie.fromJson(e)).toList();
        // save list to locale

        return list;
      } else {
        debugPrint("Error: ${response.statusCode}");
        showWarningToast(
            "The requested server could not be reached and is returning a 404 error.");
      }

      return [];
    } catch (e) {
      debugPrint("Error Channel Series : $e");
      return [];
    }
  }

  /// Movie Detail
  static Future<MovieDetail?> getMovieDetails(String movieId) async {
    try {
      final user = await AuthLocale.getUser();
      if (user != null && user.domain == "https://demo.gmax.iptv") {
        return MovieDetail.fromJson({
          "info": {
            "movie_image": "https://m.media-amazon.com/images/M/MV5BMTg0NjEwNjUxM15BMl5BanBnXkFtZTcwMzk0MjQ5Mg@@._V1_.jpg",
            "description": "High-definition demo VOD movie stream in GMAX IPTV.",
            "plot": "High-definition demo VOD movie stream in GMAX IPTV.",
            "director": "Blender Open Movie Project",
            "releasedate": "2025-01-01",
            "duration": "00:15:00"
          },
          "movie_data": {
            "stream_id": int.tryParse(movieId) ?? 301,
            "name": "GMAX Featured Movie",
            "container_extension": "mp4"
          }
        });
      }

      var url = "${user!.domain}/player_api.php";

      Response<String> response = await _dio.get(
        url,
        queryParameters: {
          "password": user.userInfo!.password,
          "username": user.userInfo!.username,
          "action": "get_vod_info",
          "vod_id": movieId,
        },
        options: _options,
      );

      debugPrint("VIDEO: ${response.realUri}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.data ?? "[]");

        final movie = MovieDetail.fromJson(json);
        return movie;
      } else {
        debugPrint("Error: ${response.statusCode}");
        showWarningToast(
            "The requested server could not be reached and is returning a 404 error.");
      }

      return null;
    } catch (e) {
      debugPrint("Error Movie $movieId: $e");
      return null;
    }
  }

  /// Serie Detail
  static Future<SerieDetails?> getSerieDetails(String serieId) async {
    try {
      final user = await AuthLocale.getUser();

      if (user == null) {
        debugPrint("User is Null");
        return null;
      }

      var url = "${user.domain}/player_api.php";

      Response<String> response = await _dio.get(
        url,
        queryParameters: {
          "password": user.userInfo!.password,
          "username": user.userInfo!.username,
          "action": "get_series_info",
          "series_id": serieId,
        },
        options: _options,
      );

      debugPrint("URL: ${response.realUri}");

      if (response.statusCode == 200) {
        //log(response.data.toString());
        final json = jsonDecode(response.data ?? "");
        final serie = SerieDetails.fromJson(json);
        return serie;
      } else {
        debugPrint("Error: ${response.statusCode}");
        showWarningToast(
            "The requested server could not be reached and is returning a 404 error.");
      }

      return null;
    } catch (e) {
      debugPrint("Error MovSerie $serieId: $e");
      return null;
    }
  }
}
