import 'package:chewie/chewie.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:flutter/material.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:video_player/video_player.dart';

class AppAudioPlayer extends StatefulWidget {
  final String url;

  AppAudioPlayer(this.url);
  @override
  _AppAudioPlayerState createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends State<AppAudioPlayer> {
  VideoPlayerController _controller;
  ChewieAudioController chewieController;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        chewieController = ChewieAudioController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: false,
        );
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? Stack(children: [
              AspectRatio(
                aspectRatio: 2,
                child: ChewieAudio(
                  controller: chewieController,
                ),
              ),
              // Align(
              //     alignment: Alignment.bottomCenter,
              //     child: GestureDetector(
              //         onTap: _playPause,
              //         child: Icon(Icons.play_circle,
              //             size: 38, color: primaryBlue)))
            ])
          : Container(child: CircularProgressIndicator()),
    );
  }

  _playPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }
}
