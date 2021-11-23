import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sunny_connect/utils/colors.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final String url;

  VideoItem(this.url);
  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _controller;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: false,
          looping: false,
        );
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? Stack(children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Chewie(
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _playPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }
}
