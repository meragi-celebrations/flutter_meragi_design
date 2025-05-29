import 'package:flutter_meragi_design/src/components/md_youtube/youtube_base.dart';

YouTubeBase getInstance() => YouTubeUnsupported();

class YouTubeUnsupported implements YouTubeBase {
  @override
  void createWebInstance() {
    throw Exception("Incorrect Platform for the Youtube widget");
  }
}
