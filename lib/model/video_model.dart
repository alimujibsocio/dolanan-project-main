import 'package:equatable/equatable.dart';

class VideoModel extends Equatable {
  final String id;
  final String videoUrl;

  const VideoModel({
    required this.id,
    this.videoUrl = '',
  });

  factory VideoModel.fromJson(String id, Map<String, dynamic> json) {
    return VideoModel(
      id: id,
      videoUrl: json["video_url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "video_url": videoUrl,
    };
  }

  @override
  List<Object?> get props => [id, videoUrl];
}

class CommentUser {
  final String id;
  final String name;
  final String comment;

  const CommentUser({
    required this.id,
    required this.name,
    required this.comment,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json["id"],
      name: json["name"],
      comment: json["comment_user"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "comment_user": comment,
    };
  }
}
