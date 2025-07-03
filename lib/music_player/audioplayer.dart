import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_app/music_player/audio_list.dart';

class TestAudioPlayer extends StatefulWidget {
  const TestAudioPlayer({
    super.key,
  });

  @override
  State<TestAudioPlayer> createState() => _TestAudioPlayerState();
}

class _TestAudioPlayerState extends State<TestAudioPlayer> {
  // late AudioPlayer audioPlayer;
  // Duration _totalDuration = Duration.zero;
  // Duration _position = Duration.zero;
  // bool _isPlaying = false;
  final List<double> speedOptions = [0.25, 0.5, 1.0, 1.25, 1.50, 1.75, 2.0];
  double _currentSpeed = 1.0;

  @override
  void initState() {
    // audioPlayer = AudioPlayer();
    // audioPlayer.setSpeed(_currentSpeed);
    // initilizePlayer();
    super.initState();
  }

  // void initilizePlayer() async {
  //   _totalDuration = await audioPlayer.setUrl(widget.audioUrl) ?? Duration.zero;
  //   _totalDuration = audioPlayer.duration ?? Duration.zero;
  //   print("duration : ${_totalDuration.inMilliseconds}");
  //   audioPlayer.positionStream.listen((val) {
  //     setState(() {
  //       _position = val;
  //     });
  //   });
  //   audioPlayer.playerStateStream.listen((play) {
  //     setState(() {
  //       _isPlaying = play.playing;
  //     });
  //   });
  // }

  String _formatDuration(Duration duration) {
    return DateFormat('mm:ss').format(DateTime(0).add(duration));
  }

  @override
  Widget build(BuildContext context) {
    // print(_position.inMilliseconds);
    // final audio = context.watch<AudioManager>();
    return Consumer<AudioManager>(builder: (context, audio, _) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            BackButton(color: Colors.black, onPressed: () {}),
            Slider(
                min: 0,
                max: audio.totalDuration.inMilliseconds.toDouble(),
                value: audio.currentPostion.inMilliseconds
                    .clamp(0, audio.totalDuration.inMilliseconds.toDouble())
                    .toDouble(),
                onChanged: (val) {
                  audio.player.seek(Duration(milliseconds: val.toInt()));
                }),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(audio.currentPostion)),
                Text(_formatDuration(audio.totalDuration)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PopupMenuButton(
                  icon: Row(
                    children: [
                      const Icon(Icons.speed, size: 20),
                      const SizedBox(width: 4),
                      Text('${_currentSpeed}x',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  onSelected: (value) {
                    setState(() {
                      _currentSpeed = value;
                    });
                    audio.player.setSpeed(_currentSpeed);
                  },
                  itemBuilder: (BuildContext context) {
                    return speedOptions.map((speed) {
                      return PopupMenuItem(
                        value: speed,
                        child: Text(speed.toString()),
                      );
                    }).toList();
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    final newPosition =
                        audio.currentPostion - const Duration(seconds: 10);
                    audio.player.seek(newPosition > Duration.zero
                        ? newPosition
                        : Duration.zero);
                  },
                  child: const Text('-10'),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      // print("speed ${audioPlayer.speed}");
                      audio.togglePlayPause();
                    },
                    icon: Icon(
                      audio.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                    )),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    final newPosition =
                        audio.currentPostion + const Duration(seconds: 10);
                    if (audio.totalDuration != Duration.zero) {
                      audio.player.seek(newPosition < audio.totalDuration
                          ? newPosition
                          : audio.totalDuration);
                    }
                  },
                  child: const Text('+10'),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}

class MiniAudioOverlay extends StatelessWidget {
  const MiniAudioOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioManager>(
      builder: (context, audio, _) {
        // if (!audio.isAudioAvailable) return const SizedBox.shrink();

        return Container(
          height: 60,
          decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(audio.currentTitle ?? '', overflow: TextOverflow.ellipsis),
              IconButton(
                icon: Icon(audio.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () => audio.togglePlayPause(),
              ),
            ],
          ),
        );
      },
    );
  }
}






// class AudioManager {
//   static final AudioManager _instance = AudioManager._internal();
//   factory AudioManager() => _instance;

//   AudioPlayer? _currentPlayer;

//   AudioManager._internal();

//   Future<void> play(AudioPlayer player) async {
//     if (_currentPlayer != null && _currentPlayer != player) {
//       await _currentPlayer!.pause();
//     }
//     _currentPlayer = player;
//     await player.play();
//   }

//   void register(AudioPlayer player) {
//     if (_currentPlayer == null) _currentPlayer = player;
//   }

//   void pauseAll() async {
//     await _currentPlayer?.pause();
//     _currentPlayer = null;
//   }
// }