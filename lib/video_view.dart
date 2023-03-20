import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

import 'player.dart';

class VideoView extends StatefulWidget {
  final Player player;

  const VideoView(this.player, {Key? key}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: _onTapVideo,
      child: Stack(
        children: [
          AbsorbPointer(
            absorbing: true,
            child: FijkView(
              player: widget.player,
            ),
          ),
          if (widget.player.state == FijkState.paused)
            Align(
              alignment: Alignment.center,
              child:
                  Image.asset('asset/images/play.png', width: 70, height: 70),
            ),
        ],
      ),
    ));
  }

  void _onTapVideo() {
    print("onTapVideo");
    var player = widget.player;
    if (player.state == FijkState.paused) {
      player.start();
    } else {
      player.pause();
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.release();
  }
}
