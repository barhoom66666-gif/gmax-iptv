import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:go_router/go_router.dart';

import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:mbark_iptv/presentation/screens/screens.dart';

import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/random/random_movie_bloc.dart';
import '../logic/cubits/categories/categories_cubit.dart';
import '../logic/cubits/favorites/favorites_cubit.dart';
import '../logic/cubits/settings/settings_cubit.dart';
import '../logic/cubits/watch/watching_cubit.dart';
import '../repository/models/channel_movie.dart';
import '../repository/models/channel_serie.dart';
import '../repository/models/offer.dart';
import '../repository/models/serie_details.dart';
import '../repository/models/video.dart';

part 'colors.dart';

part 'constants.dart';

part 'date_format.dart';

part 'functions.dart';

part 'routes.dart';

part 'themes.dart';

part 'toast.dart';

part 'ads.dart';
