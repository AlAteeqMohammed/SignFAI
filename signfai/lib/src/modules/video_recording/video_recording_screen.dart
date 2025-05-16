import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signfai/src/Localization/app_localizations.dart';
import 'package:signfai/src/modules/home/home_screen.dart';
import 'package:signfai/src/shared/styles/colors.dart';
import '../../shared/components/components.dart';
import 'cubit/video_recording_cubit.dart';

class VideoRecordingScreen extends StatelessWidget {
  final int id;
  const VideoRecordingScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoRecordingCubit()..initializeCamera(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "SIGNFAI",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        body: BlocConsumer<VideoRecordingCubit, VideoRecordingState>(
          listener: (context, state) {
            if (state is VideoUploadInProgress) {
              circularProgress(context);
            }
            if (state is VideoUploadSuccess) {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) => StatusDialog(
                  title: 'Great You Passed',
                  message: 'Video is true.\n Similarity Score: ${state.x}',
                  isSuccess: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    navigateAndFinish(context, const HomeScreen());
                  },
                ),
              );
            } else if (state is VideoUploadFailure) {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) => StatusDialog(
                  title: 'Unfortunately repeat video recording',
                  message: state.error,
                  isSuccess: false,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is VideoRecordingInitial) {
              return const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 8,
                      backgroundColor: thirdColor,
                      color: primaryColor));
            }
            return Column(
              children: [
                Expanded(
                  child: CameraPreview(
                      VideoRecordingCubit.get(context).cameraController!),
                ),
                if (state is VideoRecordingReady ||
                    state is VideoRecordingComplete)
                  buildButton(
                      width: 150,
                      height: 35,
                      fontSize: 12,
                      radius: 10,
                      text: AppLocalizations.of(context)
                          .translate('start_recording')!,
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      borderColor: primaryColor,
                      function: () {
                        VideoRecordingCubit.get(context).startRecording();
                      }),
                if (state is VideoRecordingInProgress)
                  buildButton(
                      width: 150,
                      height: 35,
                      fontSize: 12,
                      radius: 10,
                      text: AppLocalizations.of(context)
                          .translate('stop_recording')!,
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      borderColor: primaryColor,
                      function: () {
                        VideoRecordingCubit.get(context).stopRecording();
                      }),
                if (state is VideoRecordingComplete)
                  buildButton(
                      width: 150,
                      height: 35,
                      fontSize: 12,
                      radius: 10,
                      text: AppLocalizations.of(context)
                          .translate('upload_video')!,
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      borderColor: primaryColor,
                      function: () {
                        context
                            .read<VideoRecordingCubit>()
                            .uploadVideo(state.result, id);
                      }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StatusDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onPressed;
  final bool isSuccess;

  const StatusDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onPressed,
    this.isSuccess = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: isSuccess ? Colors.green : Colors.red,
            radius: 30,
            child: Icon(
              isSuccess ? Icons.check : Icons.close,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isSuccess ? Colors.green : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
