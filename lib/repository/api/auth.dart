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
      final cleanUser = username.trim();
      final cleanPass = password.trim();
      var cleanUrl = url.trim().replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'/+$'), '');
      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        cleanUrl = 'http://$cleanUrl';
      }

      if (cleanUrl == "https://demo.gmax.iptv" || cleanUser == "demo") {
        final demoJson = {
          "user_info": {
            "username": "demo",
            "password": "demo",
            "message": "Alzaabi TV Demo Active",
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
            "time_now": "2026-11-23 12:00:00",
            "process": true
          }
        };
        final user = UserModel.fromJson(
            demoJson, accountName, "https://demo.gmax.iptv", typeLogin, 1);
        await AuthLocale.logOut();
        if (addToPlayList) {
          await AuthLocale.saveUser(user);
        } else {
          await AuthLocale.updateStatusUser(user.accountName);
        }
        return user;
      }

      // Build candidate URLs: try :8080 and :2095 automatically to bypass ISP port-80 blocks (like Etisalat safe.etisalat.ae)
      final Uri parsed = Uri.parse(cleanUrl);
      final String baseHost = "${parsed.scheme}://${parsed.host}";
      final List<String> candidates = [];
      if (!parsed.hasPort || parsed.port == 80) {
        candidates.add("$baseHost:8080");
        candidates.add("$baseHost:2095");
        candidates.add(cleanUrl);
      } else {
        candidates.add(cleanUrl);
        if (parsed.port != 8080) candidates.add("$baseHost:8080");
        if (parsed.port != 2095) candidates.add("$baseHost:2095");
      }

      for (final candidateDomain in candidates) {
        try {
          final link =
              "$candidateDomain/player_api.php?username=${Uri.encodeComponent(cleanUser)}&password=${Uri.encodeComponent(cleanPass)}";
          final Response<String> response = await _dio.get(
            link,
            options: Options(
              headers: {'User-Agent': 'IPTVSmartersPlayer'},
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
            ),
          );

          if (response.statusCode == 200 && response.data != null) {
            final body = response.data!.trim();
            if (body.startsWith('{') && body.contains('user_info')) {
              final Map<String, dynamic> json = jsonDecode(body);
              final user = UserModel.fromJson(
                  json, accountName, candidateDomain, typeLogin, 1);

              await AuthLocale.logOut();
              if (addToPlayList) {
                await AuthLocale.deleteUser(accountName);
                await AuthLocale.saveUser(user);
              } else {
                await AuthLocale.updateStatusUser(user.accountName);
              }
              return user;
            }
          }
        } catch (innerErr) {
          debugPrint("Candidate $candidateDomain failed: $innerErr");
        }
      }

      showWarningToast("تعذر الاتصال بالسيرفر، تأكد من البيانات");
      return null;
    } catch (e) {
      debugPrint("Error: $e");
      showWarningToast("Error: $e");
      return null;
    }
  }

  Future<AdsServer?> getServerAds() async {
    return null;
  }
}
