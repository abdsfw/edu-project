// import 'package:educational_app/core/utils/styles.dart';
// import 'package:flutter/material.dart';
//
// class VideoPlayer extends StatelessWidget {
//   const VideoPlayer({super.key, required this.url, required this.name});
//   final String url;
//   final String name;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           name,
//           style: Styles.textStyle18White,
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:educational_app/core/utils/color_app.dart';
import 'package:educational_app/core/widgets/custom_Loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import '../../../../../constants.dart';
import '../../../../../core/cache/cashe_helper.dart';
import '../../../../../core/utils/encrypt.dart';
import '../../../../../core/utils/styles.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    Key? key,
    required this.url,
    required this.name,
    required this.videoFile,
  }) : super(key: key);
  final String? url;
  final String? name;
  final File? videoFile;
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  _VideoPlayerScreenState();
  @override
  void initState() {
    super.initState();
    // String sharedLink = '';
    // String directLink = '';
    // if (widget.videoFile == null) {
    //   // sharedLink = Encryption.decrypt(widget.url!);
    //   // directLink = convertDriveLink(sharedLink);
    // } // print('Converted Link: $directLink');
    // print('shared link :$sharedLink');

    try {
      if (widget.videoFile == null) {
        print('hereeeeeeeeeeee');
        print(widget.url);

        _controller = VideoPlayerController.networkUrl(
          Uri.parse(
            // 'https://files.testfile.org/Video%20MP4%2FOcean%20-%20testfile.org.mp4',
            '${Constants.kDefaultDomain}${widget.url}',
            // "https://timeengcom.com/Al-amin/public/videos/170%20-%20Environment%20Setup.mp4",
            // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          ),
          videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: true,
          ),
          httpHeaders: {
            "Authorization":
                "Bearer ${CasheHelper.getData(key: Constants.kToken)}",
          },
        )..initialize().then((_) {
            setState(() {});
          });
      } else {
        _controller = VideoPlayerController.file(
          widget.videoFile!,
        )..initialize().then((_) {
            setState(() {});
          });
      }
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: true,
        autoInitialize: false,
        errorBuilder: (context, errorMessage) {
          return const Center(
            child: Text("An error occurred while playing the video."),
          );
        },
      );
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // String convertDriveLink(String sharedLink) {
  //   if (sharedLink.contains('drivesdk')) {
  //     sharedLink = sharedLink.replaceAll('drivesdk', 'sharing');
  //   }
  //   if (sharedLink.contains('/file/d/') &&
  //       sharedLink.contains('/view?usp=sharing')) {
  //     final startIdx = sharedLink.indexOf('/file/d/') + 8;
  //     final endIdx = sharedLink.indexOf('/view?usp=sharing');
  //     if (startIdx < endIdx) {
  //       final fileId = sharedLink.substring(startIdx, endIdx);
  //       return 'https://drive.google.com/uc?export=download&id=$fileId';
  //     }
  //   }
  //   return sharedLink;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.name!,
          style: Styles.textStyle18White,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
      ),
      body: _controller.value.isInitialized
          ? Chewie(
              controller: _chewieController,
            )
          : const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'please wait',
                    style: Styles.textStyle15PriCol,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SpinKitThreeBounce(
                    color: AppColor.kPrimaryColor,
                    size: 15,
                    // size: size,
                  ),
                ],
              ),
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;

//   VideoPlayerScreen({required this.videoUrl});

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool _isFullScreen = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         // Ensure the first frame is shown
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player'),
//       ),
//       body: Center(
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             _controller.value.isInitialized
//                 ? AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: VideoPlayer(_controller),
//                   )
//                 : CircularProgressIndicator(), // Show a loading indicator until the video is initialized
//             _buildControls(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (_controller.value.isPlaying) {
//             _controller.pause();
//           } else {
//             _controller.play();
//           }
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }

//   Widget _buildControls() {
//     return _isFullScreen
//         ? Container() // Hide controls when in full screen
//         : Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   _toggleFullScreen();
//                 },
//                 icon: Icon(Icons.fullscreen),
//               ),
//               Expanded(
//                 child: VideoProgressIndicator(
//                   _controller,
//                   allowScrubbing: true,
//                   colors: VideoProgressColors(
//                     playedColor: Colors.red,
//                     backgroundColor: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           );
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//     });

//     if (_isFullScreen) {
//       _enterFullScreen();
//     } else {
//       _exitFullScreen();
//     }
//   }

//   void _enterFullScreen() {
//     _controller.pause(); // Pause the video when entering full screen
//     _controller.setVolume(0); // Mute the volume in full screen

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text('Full Screen Video'),
//           ),
//           body: Center(
//             child: AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _exitFullScreen();
//             },
//             child: Icon(Icons.fullscreen_exit),
//           ),
//         ),
//       ),
//     );
//   }

//   void _exitFullScreen() {
//     _controller.setVolume(1); // Restore volume when exiting full screen
//     _controller.play(); // Resume playing when exiting full screen
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
