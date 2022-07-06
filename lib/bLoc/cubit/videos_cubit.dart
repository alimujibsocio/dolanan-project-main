import 'package:ali_project_app/model/video_model.dart';
import 'package:ali_project_app/services/video_player_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  VideosCubit() : super(VideosInitial());

  void fetchVideos() async {
    try {
      emit(VideosInitial());
      List<VideoModel> videos = await VideoPlayerService().fetchVideo();

      emit(VideosSuccess(videos));
    } catch (e) {
      emit(VideosFailed(e.toString()));
    }
  }
}
