part of 'video_recording_cubit.dart';

@immutable
sealed class VideoRecordingState {}

class VideoRecordingInitial extends VideoRecordingState {}

class VideoRecordingReady extends VideoRecordingState {}

class VideoRecordingInProgress extends VideoRecordingState {}

class VideoRecordingComplete extends VideoRecordingState {
  final VideoRecordingResult result;

  VideoRecordingComplete(this.result);
}

class VideoUploadInProgress extends VideoRecordingState {}

class VideoUploadSuccess extends VideoRecordingState {
  final double x;

  VideoUploadSuccess(this.x);
}

class VideoUploadFailure extends VideoRecordingState {
  final String error;

  VideoUploadFailure(this.error);
}
