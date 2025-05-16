import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signfai/core/locator.dart';
import 'package:signfai/core/shared_prefrence_repository.dart';
import 'package:signfai/src/shared/end_points.dart';

part 'video_recording_state.dart';

class VideoRecordingCubit extends Cubit<VideoRecordingState> {
  VideoRecordingCubit() : super(VideoRecordingInitial());

  static VideoRecordingCubit get(context) => BlocProvider.of(context);
  CameraController? cameraController;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await cameraController!.initialize();
    emit(VideoRecordingReady());
  }

  Future<void> startRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      emit(VideoRecordingInProgress());
    } catch (e) {
      emit(VideoUploadFailure(e.toString()));
    }
  }

  Future<void> stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      final XFile videoFile = await cameraController!.stopVideoRecording();
      if (kIsWeb) {
        final Uint8List videoData = await videoFile.readAsBytes();
        emit(VideoRecordingComplete(VideoRecordingResult.web(videoData)));
      } else {
        emit(VideoRecordingComplete(
            VideoRecordingResult.mobile(videoFile.path)));
      }
    } catch (e) {
      emit(VideoUploadFailure(e.toString()));
    }
  }

  Future<void> uploadVideo(VideoRecordingResult videoResult, int id) async {
    emit(VideoUploadInProgress());
    String token =
        locator<SharedPreferencesRepository>().getData(key: 'access');

    try {
      String videoString;
      if (videoResult.isWeb) {
        videoString = base64Encode(videoResult.webData!);
      } else {
        final File videoFile = File(videoResult.mobilePath!);
        videoString = base64Encode(await videoFile.readAsBytes());
      }

      var url = Uri.parse("${ConstantsService.baseUrl}videos/$id/complete/");
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(
              <String, String>{"video": "data:video/mp4;base64,$videoString"}));

      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseBody["completed"] == true) {
          emit(VideoUploadSuccess(responseBody["similarity_score"]));
        } else {
          emit(VideoUploadFailure(
              "Video is not true, Try again.\nSimilarity Score: ${responseBody["similarity_score"]}"));
        }
      } else {
        emit(VideoUploadFailure(responseBody["detail"]));
      }
    } catch (e) {
      emit(VideoUploadFailure(
          "Something went wrong. Try recording video again."));
    }
  }

  @override
  Future<void> close() {
    cameraController?.dispose();
    return super.close();
  }
}

class VideoRecordingResult {
  final bool isWeb;
  final String? mobilePath;
  final Uint8List? webData;

  VideoRecordingResult.web(this.webData)
      : isWeb = true,
        mobilePath = null;
  VideoRecordingResult.mobile(this.mobilePath)
      : isWeb = false,
        webData = null;
}
