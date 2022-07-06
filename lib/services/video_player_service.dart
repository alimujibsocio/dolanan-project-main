import 'package:ali_project_app/model/video_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoPlayerService {
  final CollectionReference _videoRef =
      FirebaseFirestore.instance.collection('videos');

  Future<void> saveVideo(String urlVideo) async {
    try {
      _videoRef.doc().set({
        "video_url": urlVideo,
        "comment": [
          {
            "name": "dita",
            "comment_user": "wkwkwk",
          }
        ],
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VideoModel>> fetchVideo() async {
    try {
      QuerySnapshot result = await _videoRef.get();

      List<VideoModel> videos = result.docs.map((e) {
        return VideoModel.fromJson(e.id, e.data() as Map<String, dynamic>);
      }).toList();

      return videos;
    } catch (e) {
      rethrow;
    }
  }
}
