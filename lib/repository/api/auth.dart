part of 'api.dart';

class AuthApi {
  Future<UserModel?> registerUser(
    String username,
    String password,
    String url,
    String accountName,
    String typeLogin,
    bool addToPlayList,
  ) async {
    try {
      if (url == "https://demo.gmax.iptv" || username == "demo") {
        final demoJson = {
          "user_info": {
            "username": "demo",
            "password": "demo",
            "message": "GMAX Demo Active",
            "auth": 1,
            "status": "Active",
            "exp_date": "1893456000",
            "is_trial": "0",
            "active_cons": "1",
            "created_at": "1700000000",
            "max_connections": "5",
            "allowed_output_formats": ["m3u8", "ts", "rtmp"]
          },
          "server_info": {
            "url": "https://demo.gmax.iptv",
            "port": "443",
            "https_port": "443",
            "server_protocol": "https",
            "rtmp_port": "80",
            "timezone": "UTC",
            "timestamp_now": 1700000000,
            "time_now": "2026-11-22 12:00:00",
            "process": true
          }
        };
        final user = UserModel.fromJson(demoJson, accountName, "https://demo.gmax.iptv", typeLogin, 1);
        await AuthLocale.logOut();
        if (addToPlayList) {
          await AuthLocale.saveUser(user);
        } else {
          await AuthLocale.updateStatusUser(user.accountName);
        }
        return user;
      }

      var link = "$url/player_api.php?username=$username&password=$password";

      final Response<String> response = await _dio.get(link);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.data ?? "");
        final user = UserModel.fromJson(json, accountName, url, typeLogin, 1);

        if (addToPlayList) {
          //create new
          await AuthLocale.logOut();
          await AuthLocale.saveUser(user);
        } else {
          //update user active to 1
          await AuthLocale.logOut();
          await AuthLocale.updateStatusUser(user.accountName);
        }

        return user;
      } else {
        debugPrint("Error ${response.statusCode}");

        return null;
      }
    } catch (e) {
      debugPrint("Error: $e");
      showWarningToast("Error: $e");
      return null;
    }
  }

  Future<AdsServer?> getServerAds() async {
    return null;
    /*  try {
      Response<String> response = await _dio.get(kServerAds);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.data ?? "");
        final serverAds = AdsServer.fromJson(json);

        return serverAds;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error server ads: $e");
      return null;
    }*/
  }

// Future<String?> ignoreSSLRequests(String url) async {
//   try {
//     final Response<String> response = await _dio.post(
//         "https://mouadzizi.com/applications/ignore_sll_iptv.php",
//         data: {
//           "url": url,
//         });

//     if (response.statusCode == 200) {
//       debugPrint("RESULT: ${response.data}");
//       return response.data;
//     } else {
//       debugPrint("Error ${response.statusCode}");
//       return null;
//     }
//   } catch (e) {
//     debugPrint("Error: $e");
//     return null;
//   }
// }
}
