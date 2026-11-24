part of '../api/api.dart';

class AuthLocale {
  static String _normalizeDomain(String rawDomain) {
    final clean = rawDomain.trim().replaceAll(RegExp(r'/+$'), '');
    if (clean == "https://demo.gmax.iptv" || clean.isEmpty) return clean;
    if (clean.contains("business-cloud-8.ru")) {
      return "http://cf.uscahd.xyz";
    }
    return clean;
  }

  static Future<bool> saveUser(UserModel user) async {
    try {
      // Remove any existing entry with the exact same username OR exact same account_name
      final existing = await _sqlDb.readDataQuery(tableUsers);
      for (final row in existing) {
        final rowAcc = row['account_name']?.toString() ?? '';
        String rowUser = '';
        try {
          if (row['user_info'] != null) {
            final uMap = row['user_info'] is String
                ? jsonDecode(row['user_info'])
                : row['user_info'];
            rowUser = uMap['username']?.toString() ?? '';
          }
        } catch (_) {}
        if (rowAcc == user.accountName ||
            (rowUser.isNotEmpty && rowUser == (user.userInfo?.username ?? ''))) {
          await _sqlDb.deleteData("DELETE FROM '$tableUsers' WHERE id = ${row['id']}");
        }
      }

      await _sqlDb.insertMapData(
        tableUsers,
        user.toJson(),
      );
      return true;
    } catch (e) {
      debugPrint("Error Save New User: $e");
      return false;
    }
  }

  static Future<UserModel?> getUser() async {
    try {
      final users = await _sqlDb.readDataQuery(
        tableUsers,
        where: 'active = ?',
        whereArgs: [1],
      );

      if (users.isNotEmpty) {
        final user = users.first;
        return UserModel.fromJson(
          user,
          user['account_name'],
          _normalizeDomain(user['domain']?.toString() ?? ''),
          user['type_login'],
          user['active'],
        );
      }
      return null;
    } catch (e) {
      debugPrint("Error Get save User: $e");
      return null;
    }
  }

  static Future<List<UserModel>> getListUsers() async {
    try {
      final users = await _sqlDb.readDataQuery(tableUsers);
      return users
          .map((user) => UserModel.fromJson(
                user,
                user['account_name'],
                _normalizeDomain(user['domain']?.toString() ?? ''),
                user['type_login'],
                user['active'],
              ))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      debugPrint("Error Get save User: $e");
      return [];
    }
  }

  static Future<bool> logOut() async {
    try {
      final users = await _sqlDb.readDataQuery(
        tableUsers,
        where: 'active = ?',
        whereArgs: [1],
      );

      for (var user in users) {
        await _sqlDb.updateData(
            "UPDATE '$tableUsers' SET 'active' = '0' WHERE id = ${user['id']}");
      }

      return true;
    } catch (e) {
      debugPrint("Error LogOut User: $e");
      return false;
    }
  }

  static Future<bool> deleteUser(String accountName) async {
    try {
      final users = await _sqlDb.readDataQuery(
        tableUsers,
        where: 'account_name = ?',
        whereArgs: [accountName],
      );

      for (var user in users) {
        await _sqlDb
            .deleteData("DELETE FROM '$tableUsers' WHERE id = ${user['id']}");
      }

      return true;
    } catch (e) {
      debugPrint("Error LogOut User: $e");
      return false;
    }
  }

  static Future<bool> updateStatusUser(String accountName) async {
    try {
      final users = await _sqlDb.readDataQuery(
        tableUsers,
        where: 'account_name = ?',
        whereArgs: [accountName],
      );

      for (var user in users) {
        await _sqlDb.updateData(
            "UPDATE '$tableUsers' SET 'active' = '1' WHERE id = ${user['id']}");
      }

      return true;
    } catch (e) {
      debugPrint("Error LogOut User: $e");
      return false;
    }
  }
}
