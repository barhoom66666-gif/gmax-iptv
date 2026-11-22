import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';

import 'package:mbark_iptv/repository/models/channel_movie.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../helpers/helpers.dart';
import '../models/ads.dart';
import '../models/category.dart';
import '../models/channel_live.dart';
import '../models/channel_serie.dart';
import '../models/movie_detail.dart';
import '../models/serie_details.dart';
import '../models/user.dart';
import '../models/watching.dart';

part '../locale/locale.dart';

part '../locale/download.dart';

part '../locale/favorites.dart';

part 'auth.dart';

part '../locale/sql_db.dart';

part 'iptv.dart';

final _sqlDb = SqlDb();
final _dio = Dio();

final _options = Options(
  followRedirects: false,
  validateStatus: (status) {
    return status! < 500;
  },
  receiveDataWhenStatusError: true,
  sendTimeout: const Duration(seconds: 30),
);
