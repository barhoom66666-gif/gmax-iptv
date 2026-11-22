class EpgModel {
  final String? id;
  final String? epgId;
  final String? title;
  final String? lang;
  final String? start;
  final String? end;
  final String? description;
  final String? channelId;
  final String? startTimestamp;
  final String? stopTimestamp;
  final String? streamId;

  EpgModel({
    this.id,
    this.epgId,
    this.title,
    this.lang,
    this.start,
    this.end,
    this.description,
    this.channelId,
    this.startTimestamp,
    this.stopTimestamp,
    this.streamId,
  });

  EpgModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        epgId = json['epg_id'] as String?,
        title = json['title'] as String?,
        lang = json['lang'] as String?,
        start = json['start'] as String?,
        end = json['end'] as String?,
        description = json['description'] as String?,
        channelId = json['channel_id'] as String?,
        startTimestamp = json['start_timestamp'] as String?,
        stopTimestamp = json['stop_timestamp'] as String?,
        streamId = json['stream_id'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'epg_id': epgId,
        'title': title,
        'lang': lang,
        'start': start,
        'end': end,
        'description': description,
        'channel_id': channelId,
        'start_timestamp': startTimestamp,
        'stop_timestamp': stopTimestamp,
        'stream_id': streamId
      };
}
