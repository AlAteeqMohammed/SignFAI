import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());

  static VideoCubit get(context) => BlocProvider.of(context);

  VideoPlayerController? videoController;

  void refresh() {
    emit(VideoRefresh());
  }
}
