import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveScreenHelper {
  late VideoPlayerController videoController;
  bool isVideoReady = false;

  int userCredits = 0;
  final betController = TextEditingController();
  final commentController = TextEditingController();

  final String sampleVideoUrl =
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  void dispose() {
    videoController.dispose();
    betController.dispose();
    commentController.dispose();
  }
}
