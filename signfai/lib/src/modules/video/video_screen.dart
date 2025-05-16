import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signfai/src/Localization/app_localizations.dart';
import 'package:signfai/src/modules/video_recording/video_recording_screen.dart';
import 'package:signfai/src/shared/components/components.dart';
import 'package:signfai/src/shared/styles/colors.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
    required this.link,
    required this.id,
  });

  final String link;
  final int id;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.link));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(_videoListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration) {
      setState(() {});
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    });
  }

  void _restartVideo() {
    _controller.seekTo(Duration.zero);
    _controller.play();
  }

  Widget _buildControls(BuildContext context) {
    final bool isEnded =
        _controller.value.position >= _controller.value.duration;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isEnded
              ? Icons.replay
              : (_controller.value.isPlaying ? Icons.pause : Icons.play_arrow)),
          onPressed: () {
            setState(() {
              if (isEnded) {
                _restartVideo();
              } else {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay_10),
          onPressed: () {
            final newPosition =
                _controller.value.position - const Duration(seconds: 10);
            _controller.seekTo(newPosition);
          },
        ),
        IconButton(
          icon: const Icon(Icons.forward_10),
          onPressed: () {
            final newPosition =
                _controller.value.position + const Duration(seconds: 10);
            _controller.seekTo(newPosition);
          },
        ),
        IconButton(
          icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
          onPressed: _toggleFullScreen,
        ),
        Visibility(
          visible: !_isFullScreen,
          child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _isFullScreen
              ? Scaffold(
                  body: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_controller),
                          _buildControls(context),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: const EdgeInsets.all(8.0),
                    ),
                    _buildControls(context),
                    ValueListenableBuilder(
                      valueListenable: _controller,
                      builder: (context, VideoPlayerValue value, child) {
                        return Text(
                          '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                          style: const TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              color: Colors.white),
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    buildButton(
                        width: 175,
                        text: AppLocalizations.of(context)
                            .translate('video_try')!,
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        borderColor: primaryColor,
                        function: () {
                          navigateTo(
                              context, VideoRecordingScreen(id: widget.id));
                        })
                  ],
                );
        } else {
          return const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 8,
                  backgroundColor: thirdColor,
                  color: primaryColor));
        }
      },
    );
  }
}
