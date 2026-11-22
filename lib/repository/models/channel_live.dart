import '../../helpers/helpers.dart';

class ChannelLive {
  final String? id;
  final String? num;
  final String? name;
  final String? streamType;
  final String? streamId;
  final String? streamIcon;
  final String? epgChannelId;
  final String? added;

  final String? categoryId;
  final String? customSid;
  final String? tvArchive;
  final String? directSource;
  final String? tvArchiveDuration;

  ChannelLive({
    this.id,
    this.num,
    this.name,
    this.streamType,
    this.streamId,
    this.streamIcon,
    this.epgChannelId,
    this.added,
    this.categoryId,
    this.customSid,
    this.tvArchive,
    this.directSource,
    this.tvArchiveDuration,
  });

  ChannelLive.fromJson(Map<String, dynamic> json)
      : id = sanitizeString(json['id']),
        num = sanitizeString(json['num']),
        name = sanitizeString(json['name']),
        streamType = sanitizeString(json['stream_type']),
        streamId = sanitizeString(json['stream_id']),
        streamIcon = sanitizeString(json['stream_icon']),
        epgChannelId = sanitizeString(json['epg_channel_id']),
        added = sanitizeString(json['added']),
        categoryId = sanitizeString(json['category_id']),
        customSid = sanitizeString(json['custom_sid']),
        tvArchive = sanitizeString(json['tv_archive']),
        directSource = sanitizeString(json['direct_source']),
        tvArchiveDuration = sanitizeString(json['tv_archive_duration']);

  Map<String, dynamic> toJson() => {
        'num': num,
        'name': name,
        'stream_type': streamType,
        'stream_id': streamId,
        'stream_icon': streamIcon,
        'epg_channel_id': epgChannelId,
        'added': added,
        'category_id': categoryId,
        'custom_sid': customSid,
        'tv_archive': tvArchive,
        'direct_source': directSource,
        'tv_archive_duration': tvArchiveDuration
      };
}
