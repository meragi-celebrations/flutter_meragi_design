import 'package:flutter_meragi_design/src/components/md_youtube/youtube_base.dart';
import 'package:webview_flutter_platform_interface/src/webview_platform.dart';
import 'package:youtube_player_iframe_web/src/web_youtube_player_iframe_platform.dart';

YouTubeWebInstance getInstance() => YouTubeWebInstance();

class YouTubeWebInstance implements YouTubeBase {
  @override
  void createWebInstance() {
    WebViewPlatform.instance = WebYoutubePlayerIframePlatform();
  }
}
