import 'dart:convert';

import '../../helpers/helpers.dart';

class UserModel {
  final UserInfo? userInfo;
  final ServerInfo? serverInfo;
  final String accountName;
  final String domain;
  final String typeLogin; //xtreme or m3u
  final int active;

  UserModel({
    this.userInfo,
    this.serverInfo,
    required this.accountName,
    required this.domain,
    required this.typeLogin,
    required this.active,
  });

  UserModel.fromJson(
    Map<String, dynamic> json,
    String accName,
    String url,
    String typeLogin,
    int active,
  )   : userInfo = json['user_info'] != null
            ? UserInfo.fromJson((json['user_info'] is String
                    ? jsonDecode(json['user_info'])
                    : json['user_info']) as Map<String, dynamic>)
            : null,
        serverInfo = json['server_info'] != null
            ? ServerInfo.fromJson((json['server_info'] is String
                ? jsonDecode(json['server_info'])
                : json['server_info']) as Map<String, dynamic>)
            : null,
        accountName = json['account_name'] ?? accName,
        domain = sanitizeString(json['domain']) ?? url,
        typeLogin = sanitizeString(json['type_login']) ?? typeLogin,
        active = json['active'] ?? active;

  Map<String, dynamic> toJson() => {
        'user_info': jsonEncode(userInfo?.toJson()),
        'server_info': jsonEncode(serverInfo?.toJson()),
        'account_name': accountName,
        'domain': domain,
        'type_login': typeLogin,
        'active': active,
      };
}

class UserInfo {
  final String? username;
  final String? password;
  final String? message;
  final String? auth;
  final String? status;
  final String? expDate;
  final String? isTrial;
  final String? activeCons;
  final String? createdAt;
  final String? maxConnections;
  final List<String>? allowedOutputFormats;

  UserInfo({
    this.username,
    this.password,
    this.message,
    this.auth,
    this.status,
    this.expDate,
    this.isTrial,
    this.activeCons,
    this.createdAt,
    this.maxConnections,
    this.allowedOutputFormats,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : username = sanitizeString(json['username']),
        password = sanitizeString(json['password']),
        message = sanitizeString(json['message']),
        auth = sanitizeString(json['auth']),
        status = sanitizeString(json['status']),
        expDate = sanitizeString(json['exp_date']),
        isTrial = sanitizeString(json['is_trial']),
        activeCons = sanitizeString(json['active_cons']),
        createdAt = sanitizeString(json['created_at']),
        maxConnections = sanitizeString(json['max_connections']),
        allowedOutputFormats = json['allowed_output_formats'] == null
            ? []
            : (json['allowed_output_formats'] is List
                    ? json['allowed_output_formats'] as List?
                    : (json['allowed_output_formats'] is String
                        ? jsonDecode(json['allowed_output_formats']) as List?
                        : []))
                ?.map((dynamic e) => e.toString())
                .toList();

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'message': message,
        'auth': auth,
        'status': status,
        'exp_date': expDate,
        'is_trial': isTrial,
        'active_cons': activeCons,
        'created_at': createdAt,
        'max_connections': maxConnections,
        'allowed_output_formats': jsonEncode(allowedOutputFormats)
      };
}

class ServerInfo {
  final String? url;
  final String? port;
  final String? httpsPort;
  final String? serverProtocol;
  final String? rtmpPort;
  final String? timezone;
  final String? timestampNow;
  final String? timeNow;
  final String? process;

  ServerInfo({
    this.url,
    this.port,
    this.httpsPort,
    this.serverProtocol,
    this.rtmpPort,
    this.timezone,
    this.timestampNow,
    this.timeNow,
    this.process,
  });

  ServerInfo.fromJson(Map<String, dynamic> json)
      : url = sanitizeString(json['url']),
        port = sanitizeString(json['port']),
        httpsPort = sanitizeString(json['https_port']),
        serverProtocol = sanitizeString(json['server_protocol']),
        rtmpPort = sanitizeString(json['rtmp_port']),
        timezone = sanitizeString(json['timezone']),
        timestampNow = sanitizeString(json['timestamp_now']),
        timeNow = sanitizeString(json['time_now']),
        process = sanitizeString(json['process']);

  Map<String, dynamic> toJson() => {
        'url': url,
        'port': port,
        'https_port': httpsPort,
        'server_protocol': serverProtocol,
        'rtmp_port': rtmpPort,
        'timezone': timezone,
        'timestamp_now': timestampNow,
        'time_now': timeNow,
        'process': process,
      };
}
