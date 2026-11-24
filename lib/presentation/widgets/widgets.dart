import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mbark_iptv/logic/cubits/settings/settings_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../helpers/helpers.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/random/random_movie_bloc.dart';
import '../../logic/cubits/favorites/favorites_cubit.dart';
import '../../logic/cubits/search/search_cubit.dart';
import '../../logic/cubits/watch/watching_cubit.dart';
import '../../repository/api/api.dart';
import '../../repository/models/channel_live.dart';
import '../../repository/models/offer.dart';
import '../../repository/models/serie_details.dart';
import '../../repository/models/user.dart';
import '../../repository/models/video.dart';
import '../../repository/models/watching.dart';
import '../screens/screens.dart';

part 'appbar.dart';

part 'register.dart';

part 'home.dart';

part 'movie.dart';

part 'settings.dart';

part 'player.dart';

part 'ads.dart';
