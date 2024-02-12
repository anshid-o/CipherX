import 'dart:developer';
import 'dart:io';

import 'package:cypher_x/app/entry_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player_win/video_player_win.dart';

class IntroPage extends StatefulWidget {
  @override
  State<IntroPage> createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  ValueNotifier<WinVideoPlayerController> controller =
      ValueNotifier(WinVideoPlayerController.file(File("assets/intro.mp4")));

  void reload() {
    controller.value.initialize().then((value) {
      if (controller.value.value.isInitialized) {
        controller.value.play();
        setState(() {});

        controller.value.addListener(() {
          if (controller.value.value.position >=
              controller.value.value.duration) {
            // Video playback completed, navigate to the next page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EntryPage()),
            );
          }
        });
      } else {
        log("video file load failed");
      }
    }).catchError((e) {
      log("controller!.value.initialize() error occurs: $e");
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void dispose() {
    super.dispose();
    controller.value.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: WinVideoPlayer(controller.value),
    ));
  }
}
