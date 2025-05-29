import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/loading_widget.dart';
import 'package:flutter_meragi_design/src/extensions/context.dart';
import 'package:flutter_meragi_design/src/theme/extensions/colors.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class MDVideoPlayer extends StatefulWidget {
  const MDVideoPlayer({super.key, required this.url});

  final String url;

  @override
  State<MDVideoPlayer> createState() => _MDVideoPlayerState();
}

class _MDVideoPlayerState extends State<MDVideoPlayer> {
  late final VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FutureBuilder(
          future: controller.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MDLoadingIndicator();
            }
            return ChangeNotifierProvider(create: (context) {
              return ChewieController(
                videoPlayerController: controller,
                aspectRatio: 16 / 9,
                errorBuilder: (context, errorMessage) {
                  return ColoredBox(
                    color: context.theme.colors.background.overlayDark,
                    child:
                        Center(child: Icon(Icons.error, color: context.theme.colors.background.overlayLight, size: 16)),
                  );
                },
              );
            }, builder: (context, child) {
              return Chewie(controller: context.read<ChewieController>());
            });
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
