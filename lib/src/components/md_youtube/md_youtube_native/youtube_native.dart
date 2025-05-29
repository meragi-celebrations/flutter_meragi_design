import 'package:flutter_meragi_design/src/components/md_youtube/youtube_base.dart';

YouTubeBase getInstance() => YouTubeNativeInstance();

class YouTubeNativeInstance implements YouTubeBase {
  @override
  void createWebInstance() {}
}
