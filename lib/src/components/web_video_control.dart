import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:provider/provider.dart';

class WebVideoControl extends StatelessWidget {
  const WebVideoControl({
    super.key,
    this.iconSize = 20,
    this.fontSize = 12,
    this.progressBarSettings,
  });

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    return FlickShowControlsActionWeb(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: const FlickAnimatedVolumeLevel(
                decoration: BoxDecoration(
                  color: Colors.black54,
                ),
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
          const Positioned.fill(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FlickPlayToggle(size: 50),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FlickAutoHideChild(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.541),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlickVideoProgressBar(
                      flickProgressBarSettings: progressBarSettings,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlickPlayToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          FlickSoundToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          Row(
                            children: <Widget>[
                              FlickCurrentPosition(
                                fontSize: fontSize,
                              ),
                              FlickAutoHideChild(
                                child: Text(
                                  ' / ',
                                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                                ),
                              ),
                              FlickTotalDuration(
                                fontSize: fontSize,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          MDMultiListenableBuilder(
                            listenables: [speedLevel],
                            builder: (context, child) {
                              FlickControlManager controlManager = Provider.of<FlickControlManager>(context);
                              return Material(
                                color: Colors.transparent,
                                child: MDTap.ghost(
                                  onPressed: () {
                                    double speed = speedLevel.value == 1
                                        ? 1.5
                                        : speedLevel.value == 1.5
                                            ? 2
                                            : 1;
                                    controlManager.setPlaybackSpeed(speed);
                                    speedLevel.value = speed;
                                  },
                                  child: Text(
                                    '${speedLevel.value}x',
                                    style: TextStyle(color: colors.content.onColor, fontSize: fontSize),
                                  ),
                                ),
                              );
                            },
                          ),
                          FlickFullScreenToggle(
                            size: iconSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

ValueNotifier<double> speedLevel = ValueNotifier(1);
