import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/web_video_control.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class MDVideoPlayer extends StatefulWidget {
  final String url;

  const MDVideoPlayer({
    super.key,
    required this.url,
  });

  @override
  State<MDVideoPlayer> createState() => _MDVideoPlayerState();
}

class _MDVideoPlayerState extends State<MDVideoPlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
        ),
      ),
      autoInitialize: true,
      autoPlay: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
          aspectRatioWhenLoading: 1,
          controls: WebVideoControl(
            iconSize: 15,
            fontSize: 12,
            progressBarSettings: FlickProgressBarSettings(
              height: 5,
              handleRadius: 5.5,
            ),
          ),
          videoFit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
}
