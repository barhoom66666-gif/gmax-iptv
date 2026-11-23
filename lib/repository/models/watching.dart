class WatchingModel {
  final String? image;
  final String title;
  final String streamId;
  double sliderValue;
  final double totalDuration;
  final String stream;

  WatchingModel({
    this.image,
    required this.streamId,
    required this.title,
    required this.stream,
    required this.sliderValue,
    required this.totalDuration,
  });

  factory WatchingModel.fromJson(Map<String, dynamic> json) {
    return WatchingModel(
      image: json["image"],
      title: json["title"],
      sliderValue: double.tryParse(json["sliderValue"].toString()) ?? 0.0,
      stream: json["stream"],
      totalDuration: double.tryParse(json['durationStrm'].toString()) ?? 0.0,
      streamId: json['streamId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "title": title,
      "sliderValue": sliderValue,
      "stream": stream,
      'durationStrm': totalDuration,
      'streamId': streamId,
    };
  }

//
}
