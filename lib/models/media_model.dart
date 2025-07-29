class MediaModel {
  final String video, createdAt, status;

  MediaModel.fromJson(Map<String, dynamic> json)
    : video = json['video'],
      createdAt = json['createdAt'],
      status = json['status'];
}
