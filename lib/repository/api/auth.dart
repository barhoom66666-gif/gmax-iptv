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
      var cleanUrl = url
          .trim()
          .replaceAll(RegExp(r'\s+'), '')
          .replaceAll(RegExp(r'/+$'), '');
      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        cleanUrl = 'http://$cleanUrl';
      }

      // Generate a unique account name if empty or generic so it never overwrites previous codes
      var finalAccountName = accountName.trim();
      if (finalAccountName.isEmpty || finalAccountName == "user") {
        finalAccountName = "كود ($cleanUser)";
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
            "time_now": "2026-11-24 12:00:00",
            "process": true
          }
        };
        final user = UserModel.fromJson(
            demoJson, finalAccountName, "https://demo.gmax.iptv", typeLogin, 1);
        await AuthLocale.logOut();
        await AuthLocale.saveUser(user);
        return user;
      }

      // Build candidate URLs including automatic UAE anti-block mirrors for World 8K
      final List<String> candidates = [];
      if (cleanUrl.contains("business-cloud-8.ru") || cleanUrl.contains("uscahd.xyz")) {
        candidates.add("http://cf.uscahd.xyz");
        candidates.add("http://pro.uscahd.xyz");
        candidates.add("http://cf.uscahd.xyz:8080");
        candidates.add("http://pro.uscahd.xyz:8080");
      }

      try {
        final Uri parsed = Uri.parse(cleanUrl);
        final String baseHost = "${parsed.scheme}://${parsed.host}";
        if (!candidates.contains(cleanUrl)) candidates.add(cleanUrl);
        if (!parsed.hasPort || parsed.port == 80) {
          if (!candidates.contains("$baseHost:8080")) candidates.add("$baseHost:8080");
          if (!candidates.contains("$baseHost:2095")) candidates.add("$baseHost:2095");
        } else {
          if (!candidates.contains(baseHost)) candidates.add(baseHost);
        }
      } catch (_) {
        if (!candidates.contains(cleanUrl)) candidates.add(cleanUrl);
      }

      for (final candidateDomain in candidates) {
        try {
          final link =
              "$candidateDomain/player_api.php?username=${Uri.encodeComponent(cleanUser)}&password=${Uri.encodeComponent(cleanPass)}";
          final Response<String> response = await _dio.get(
            link,
            options: Options(
              headers: const {'User-Agent': 'IPTVSmartersPlayer'},
              receiveTimeout: const Duration(seconds: 12),
              sendTimeout: const Duration(seconds: 12),
            ),
          );

          if (response.statusCode == 200 && response.data != null) {
            final body = response.data!.trim();
            if (body.startsWith('{') && body.contains('user_info')) {
              final Map<String, dynamic> json = jsonDecode(body);
              final uInfo = json['user_info'];
              if (uInfo is Map && (uInfo['auth'] == 0 || uInfo['auth'] == '0')) {
                showWarningToast("الكود غير مفعل أو انتهت صلاحيته");
                return null;
              }
              final user = UserModel.fromJson(
                  json, finalAccountName, candidateDomain, typeLogin, 1);

              await AuthLocale.logOut();
              await AuthLocale.saveUser(user);
              return user;
            }
          }
        } catch (innerErr) {
          debugPrint("Candidate $candidateDomain failed: $innerErr");
        }
      }

      showWarningToast("تعذر الاتصال بالسيرفر، تأكد من الرابط أو الكود");
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
