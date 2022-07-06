import 'package:ali_project_app/app/theme.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  final String videoUrl;
  const VideoApp(this.videoUrl, {Key? key}) : super(key: key);

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          // Padding(
          //     padding: const EdgeInsets.only(right: 350, top: 10,, bottom: 5),
          //     child: Ink(
          //       decoration: ShapeDecoration(
          //         color: Colors.green,
          //         shape: CircleBorder(),
          //       ),
          //       child: Center(
          //           child: RawMaterialButton(
          //         onPressed: () {},
          //         elevation: 1.0,
          //         fillColor: Colors.green,
          //         child: Icon(
          //           Icons.person,
          //           size: 25,
          //           color: Colors.white,
          //         ),
          //         padding: EdgeInsets.all(15.0),
          //         shape: CircleBorder(),
          //       )),
          //     )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Ali Mujib',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: _controller.value.isInitialized
                    ? Container(
                        // width: double.infinity,
                        height: 500,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: kGreyColor,
                          border: Border.all(
                            color: kPrimaryColor,
                            width: 0,
                          ),
                        ),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : Container(),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  // color: kPrimaryColor,
                  color: Colors.green,
                  size: 60,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.fixed,
                        duration: const Duration(seconds: 0),
                        content: isFavorite
                            ? const Text("Success like this video")
                            : const Text("Cancel like this video"),
                      ),
                    );
                  });
                },
                // child: SizedBox(
                //   width: 35.0,
                //   height: 35.0,
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 20),
                //     child: Icon(
                //       isFavorite
                //           ? Icons.thumb_up_alt_outlined
                //           : Icons.thumb_up_alt_outlined,
                //       color: isFavorite ? Colors.red : kBlackColor,
                //     ),
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: LikeButton(
                    size: 30,
                    circleColor: CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.green : Colors.black,
                        size: 30,
                      );
                    },
                    likeCount: 10,
                    countBuilder: (count, bool isLiked, String text) {
                      var color = isLiked ? Colors.green : Colors.black;
                      Widget result;
                      if (count == 0) {
                        result = Text(
                          "",
                          style: TextStyle(color: color),
                        );
                      } else
                        result = Text(
                          text,
                          style: TextStyle(color: color),
                        );
                      return result;
                    },
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(right: 200),
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.chat_bubble_outline),
              //   ),
              // ),
              // SizedBox(
              //   width: 35.0,
              //   height: 35.0,
              //   child: Column(children: [
              //     Text('Ini video'),
              //     const SizedBox(height: 15),
              //     ElevatedButton.icon(
              //         onPressed: () {},
              //         icon: const Icon(Icons.share),
              //         label: const Text('Bagikan'))
              //   ]),
              // ),
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
