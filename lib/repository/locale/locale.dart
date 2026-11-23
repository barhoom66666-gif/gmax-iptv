part of '../api/api.dart';

class AuthLocale {
  static String _normalizeDomain(String rawDomain) {
    final clean = rawDomain.trim().replaceAll(RegExp(r'/+$'), '');
    if (clean == "https://demo.gmax.iptv" || clean.isEmpty) return clean;
    try {
      final uri = Uri.parse(clean);
      if (uri.scheme == 'http' && (!uri.hasPort || uri.port == 80)) {
        return "${uri.scheme}://${uri.host}:8080";
      }
    } catch (_) {}
    return clean;
  }

  static Future<bool> saveUser(UserModel user) async {
    try {
      await _sqlDb.insertMapData(
        tableUsers,
        user.toJson(),
      );
      // debugPrint("Created: ${user.accountName} || active: ${user.active} || RES:$res");

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

      // debugPrint("Users active: ${users.length}");

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
      final users = await _sqlDb.readDataQuery(
        tableUsers,
        //  where: 'active = ?',
        // whereArgs: [1],
      );

      // debugPrint("Users active: ${users.length}");

      return users
          .map((user) => UserModel.fromJson(
                user,
                user['account_name'],
                _normalizeDomain(user['domain']?.toString() ?? ''),
                user['type_login'],
                user['active'],
              ))
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

      //TODO: update all users to active 0
      for (var user in users) {
        var response = await _sqlDb.updateData(
            "UPDATE '$tableUsers' SET 'active' = '0' WHERE id = ${user['id']}");
        debugPrint("RESPONSE user: ${user['account_name']} is $response");
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

      //TODO: update all users to active 0
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
