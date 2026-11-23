import 'dart:convert';

import '../../helpers/helpers.dart';

class ChannelSerie {
  final String? id;
  final String? num;
  final String? name;
  final String? title;
  final String? year;
  final String? streamType;
  final String? seriesId;
  final String? cover;
  final String? plot;
  final String? cast;
  final String? director;
  final String? genre;
  final String? releaseDate;
  final String? lastModified;
  final String? rating;
  final String? rating5based;
  final List<String?>? backdropPath;
  final String? youtubeTrailer;
  final String? episodeRunTime;
  final String? categoryId;
  final List<String?>? categoryIds;

  ChannelSerie({
    this.id,
    this.num,
    this.name,
    this.title,
    this.year,
    this.streamType,
    this.seriesId,
    this.cover,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.releaseDate,
    this.lastModified,
    this.rating,
    this.rating5based,
    this.backdropPath,
    this.youtubeTrailer,
    this.episodeRunTime,
    this.categoryId,
    this.categoryIds,
  });

  ChannelSerie.fromJson(Map<String, dynamic> json)
      : id = json['id'] == null ? null : sanitizeString(json['id']),
        num = sanitizeString(json['num']),
        name = sanitizeString(json['name']),
        title = sanitizeString(json['title']),
        year = sanitizeString(json['year']),
        streamType = sanitizeString(json['stream_type']),
        seriesId = sanitizeString(json['series_id']),
        cover = sanitizeString(json['cover']),
        plot = sanitizeString(json['plot']),
        cast = sanitizeString(json['cast']),
        director = sanitizeString(json['director']),
        genre = sanitizeString(json['genre']),
        releaseDate = sanitizeString(json['release_date']),
        lastModified = sanitizeString(json['last_modified']),
        rating = sanitizeString(json['rating']),
        rating5based = sanitizeString(json['rating_5based']),
        backdropPath = json['backdrop_path'] == null
            ? null
            : (json['backdrop_path'] is List
                    ? json['backdrop_path'] as List?
                    : (json['backdrop_path'] is String
                        ? jsonDecode(json['backdrop_path']) as List?
                        : []))
                ?.map((dynamic e) => sanitizeString(e))
                .toList(),
        youtubeTrailer = sanitizeString(json['youtube_trailer']),
        episodeRunTime = sanitizeString(json['episode_run_time']),
        categoryId = sanitizeString(json['category_id']),
        categoryIds = json['category_ids'] == null
            ? null
            : (json['category_ids'] is List
                    ? json['category_ids'] as List?
                    : (json['category_ids'] is String
                        ? jsonDecode(json['category_ids']) as List?
                        : []))
                ?.map((dynamic e) => sanitizeString(e))
                .toList();

  Map<String, dynamic> toJson() => {
        'num': num,
        'name': name,
        'title': title,
        'year': year,
        'stream_type': streamType,
        'series_id': seriesId,
        'cover': cover,
        'plot': plot,
        'cast': cast,
        'director': director,
        'genre': genre,
        'release_date': releaseDate,
        'releaseDate': releaseDate,
        'last_modified': lastModified,
        'rating': rating,
        'rating_5based': rating5based,
        'backdrop_path': jsonEncode(backdropPath),
        'youtube_trailer': youtubeTrailer,
        'episode_run_time': episodeRunTime,
        'category_id': categoryId,
        'category_ids': jsonEncode(categoryIds),
      };
}
