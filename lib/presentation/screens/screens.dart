import 'dart:async';

import 'dart:ui';

import 'package:azul_envato_checker/azul_envato_checker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as video;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../helpers/helpers.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/download/download_bloc.dart';
import '../../logic/cubits/categories/categories_cubit.dart';
import '../../logic/cubits/favorites/favorites_cubit.dart';
import '../../logic/cubits/search/search_cubit.dart';
import '../../logic/cubits/settings/settings_cubit.dart';
import '../../repository/api/api.dart';
import '../../repository/models/category.dart';
import '../../repository/models/channel_live.dart';
import '../../repository/models/channel_movie.dart';
import '../../repository/models/channel_serie.dart';
import '../../repository/models/movie_detail.dart';
import '../../repository/models/serie_details.dart';
import '../../repository/models/user.dart';
import '../../repository/models/video.dart';
import '../widgets/widgets.dart';

part 'user/splash.dart';

part 'welcome.dart';

part 'home/home.dart';

part 'home/screenshot.dart';

part 'movie/movie.dart';

part 'user/register.dart';

part 'user/download.dart';

part 'series/serie.dart';

part 'series/more_series.dart';

part 'movie/movie_details.dart';

part 'movie/more_movies.dart';

part 'series/serie_details.dart';

part 'player/movie_player.dart';

part 'player/serie_player.dart';

part 'player/live_player.dart';

part 'player/youtube.dart';

part 'live/live.dart';

part 'live/more_live.dart';

part 'settings/settings.dart';

part 'settings/pages/membership.dart';

part 'settings/pages/appearance.dart';

part 'settings/pages/playlist.dart';
