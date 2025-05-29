import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/md_youtube/youtube_base.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MDYoutubeWidget extends StatefulWidget {
  const MDYoutubeWidget({super.key, required this.url});

  final String url;

  @override
  State<MDYoutubeWidget> createState() => _MDYoutubeWidgetState();
}

class _MDYoutubeWidgetState extends State<MDYoutubeWidget> with WidgetsBindingObserver {
  late final YoutubePlayerController player;
  late final YouTubeNavigatorObserver _youtubeObserver;
  final ValueNotifier<bool> addInterceptor = ValueNotifier(true);
  StreamSubscription<YoutubePlayerValue>? subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    YouTubeBase().createWebInstance();
    player =
        YoutubePlayerController(params: const YoutubePlayerParams(enableJavaScript: false, showFullscreenButton: true))
          ..setFullScreenListener((value) async {
            final videoData = await player.videoData;
            final startSeconds = await player.currentTime;
            if (!mounted) return;
            final currentTime = await FullscreenYoutubePlayer.launch(
              context,
              videoId: videoData.videoId,
              startSeconds: startSeconds,
            );
            if (currentTime != null) {
              player.seekTo(seconds: currentTime, allowSeekAhead: true);
            }
          });
    _youtubeObserver = YouTubeNavigatorObserver(player);
    subscription = player.listen(playerListener);
    if (context.findAncestorStateOfType<NavigatorState>() != null) {
      Navigator.of(context).widget.observers.add(_youtubeObserver);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => loadYouTube());
  }

  Future<void> loadYouTube() async {
    await _initializeYoutube();
    if (kIsWeb) await Future.delayed(const Duration(seconds: 1), () => _initializeYoutube());
  }

  Future<void> _initializeYoutube() async {
    await player.cueVideoById(videoId: YoutubePlayerController.convertUrlToId(widget.url) ?? "");
  }

  void playerListener(YoutubePlayerValue value) {
    (value.playerState == PlayerState.playing) ? addInterceptor.value = false : addInterceptor.value = true;
  }

  @override
  Widget build(BuildContext context) {
    Set<Factory<EagerGestureRecognizer>> gesture = {};
    gesture.add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()));
    return YoutubePlayerScaffold(
      gestureRecognizers: gesture,
      backgroundColor: Colors.white,
      enableFullScreenOnVerticalDrag: false,
      autoFullScreen: false,
      controller: player,
      builder: (context, youtube) {
        return Stack(
          children: [
            Column(
              children: [
                youtube,
                YoutubeValueBuilder(
                  controller: player,
                  builder: (context, youtubeValue) {
                    return StreamBuilder<YoutubeVideoState>(
                        stream: player.videoStateStream,
                        builder: (context, snapshot) {
                          final int totalDuration = youtubeValue.metaData.duration.inMilliseconds;
                          final int current = snapshot.data?.position.inMilliseconds ?? 0;
                          return LinearProgressIndicator(
                            value: totalDuration == 0 ? 0 : current / totalDuration,
                            minHeight: 5,
                          );
                        });
                  },
                )
              ],
            ),
            MDMultiListenableBuilder(
                listenables: [addInterceptor],
                builder: (context, child) {
                  return addInterceptor.value
                      ? Positioned.fill(
                          child: PointerInterceptor(
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: GestureDetector(onTap: () => player.playVideo()),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                })
          ],
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      player.stopVideo();
    }
  }

  @override
  void deactivate() {
    if (context.findAncestorStateOfType<NavigatorState>() != null) {
      Navigator.of(context).widget.observers.remove(_youtubeObserver);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription?.cancel();
    subscription = null;
    addInterceptor.dispose();
    super.dispose();
  }
}

class YoutubeNotifier extends ChangeNotifier {
  Future<void> _initializeYoutube(String url, YoutubePlayerController player) async {
    await player.cueVideoById(videoId: YoutubePlayerController.convertUrlToId(url) ?? "");
  }

  Future<void> loadYouTube(String url, YoutubePlayerController player) async {
    await _initializeYoutube(url, player);
    await Future.delayed(const Duration(seconds: 1), () => _initializeYoutube(url, player));
  }
}

class YouTubeNavigatorObserver extends NavigatorObserver {
  final YoutubePlayerController player;

  YouTubeNavigatorObserver(this.player);

  void _stopVideo() {
    player.stopVideo();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _stopVideo();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _stopVideo();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _stopVideo();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _stopVideo();
  }
}
