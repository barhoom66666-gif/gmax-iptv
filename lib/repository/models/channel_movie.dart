import 'dart:convert';

import '../../helpers/helpers.dart';

class ChannelMovie {
  final String? id;
  final String? num;
  final String? name;
  final String? title;
  final String? year;
  final String? streamType;
  final String? streamId;
  final String? streamIcon;
  final String? rating;
  final String? rating5based;
  final String? added;
  final String? plot;
  final String? cast;
  final String? director;
  final String? genre;
  final String? releaseDate;
  final String? youtubeTrailer;
  final String? episodeRunTime;
  final String? categoryId;
  final List<String?>? categoryIds;
  final String? containerExtension;
  final String? customSid;
  final String? directSource;

  ChannelMovie({
    this.id,
    this.num,
    this.name,
    this.title,
    this.year,
    this.streamType,
    this.streamId,
    this.streamIcon,
    this.rating,
    this.rating5based,
    this.added,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.releaseDate,
    this.youtubeTrailer,
    this.episodeRunTime,
    this.categoryId,
    this.categoryIds,
    this.containerExtension,
    this.customSid,
    this.directSource,
  });

  ChannelMovie.fromJson(Map<String, dynamic> json)
      : id = sanitizeString(json['id']),
        num = sanitizeString(json['num']),
        name = sanitizeString(json['name']),
        title = sanitizeString(json['title']),
        year = sanitizeString(json['year']),
        streamType = sanitizeString(json['stream_type']),
        streamId = sanitizeString(json['stream_id']),
        streamIcon = sanitizeString(json['stream_icon']),
        rating = sanitizeString(json['rating']),
        rating5based = sanitizeString(json['rating_5based']),
        added = sanitizeString(json['added']),
        plot = sanitizeString(json['plot']),
        cast = sanitizeString(json['cast']),
        director = sanitizeString(json['director']),
        genre = sanitizeString(json['genre']),
        releaseDate = sanitizeString(json['release_date']),
        youtubeTrailer = sanitizeString(json['youtube_trailer']),
        episodeRunTime = sanitizeString(json['episode_run_time']),
        categoryId = sanitizeString(json['category_id']),
        categoryIds = json['category_ids'] == null
            ? null
            : (json['category_ids'].runtimeType == List
                    ? json['category_ids'] as List?
                    : jsonDecode(json['category_ids']) as List?)
                ?.map((dynamic e) => sanitizeString("$e"))
                .toList(),
        containerExtension = sanitizeString(json['container_extension']),
        customSid = sanitizeString(json['custom_sid']),
        directSource = sanitizeString(json['direct_source']);

  Map<String, dynamic> toJson() => {
        'num': num,
        'name': name,
        'title': title,
        'year': year,
        'stream_type': streamType,
        'stream_id': streamId,
        'stream_icon': streamIcon,
        'rating': rating,
        'rating_5based': rating5based,
        'added': added,
        'plot': plot,
        'cast': cast,
        'director': director,
        'genre': genre,
        'release_date': releaseDate,
        'youtube_trailer': youtubeTrailer,
        'episode_run_time': episodeRunTime,
        'category_id': categoryId,
        'category_ids': jsonEncode(categoryIds),
        'container_extension': containerExtension,
        'custom_sid': customSid,
        'direct_source': directSource
      };
}
