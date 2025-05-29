import 'package:flutter_meragi_design/src/components/md_youtube/md_youtube_native/youtube_unsupported.dart'
    if (dart.library.html) 'package:flutter_meragi_design/src/components/md_youtube/md_youtube_web/youtube_web.dart'
    if (dart.library.io) 'package:flutter_meragi_design/src/components/md_youtube/md_youtube_native/youtube_native.dart';

abstract class YouTubeBase {
  factory YouTubeBase() => getInstance();
  void createWebInstance();
}
