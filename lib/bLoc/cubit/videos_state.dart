part of 'videos_cubit.dart';

abstract class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object> get props => [];
}

class VideosInitial extends VideosState {}

class VideosLoading extends VideosState {}

class VideosSuccess extends VideosState {
  final List<VideoModel> videos;

  const VideosSuccess(this.videos);

  @override
  List<Object> get props => [videos];
}

class VideosFailed extends VideosState {
  final String error;

  const VideosFailed(this.error);

  @override
  List<Object> get props => [error];
}
