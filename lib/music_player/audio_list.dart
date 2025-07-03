import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:test_app/music_player/audioplayer.dart';

class AudioManager extends ChangeNotifier {
  static final AudioManager _audioManagerInstance = AudioManager._internal();
  AudioManager._internal();
  factory AudioManager() => _audioManagerInstance;
  int data = 0;

  String? _currentTitle;
  String? get currentTitle => _currentTitle;

  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;

  Duration _totalDuration = Duration.zero;
  Duration get totalDuration => _totalDuration;

  bool get isPlaying => _player.playing;
  Duration get currentPostion => _currentPostion;
  Duration _currentPostion = Duration.zero;

  bool get isAudioAvailable => _currentTitle != null;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
  }

  void updateData() {
    data += 1;
    notifyListeners();
  }

  Future<void> play(String title, String url) async {
    _currentTitle = title;
    _totalDuration = await _player.setUrl(url) ?? Duration.zero;

    _player.setSpeed(1);
    _player.play();
    _player.positionStream.listen((val) {
      _currentPostion = val;
      notifyListeners();
    });
    // _player.playerStateStream.listen((play) {
    //   setState(() {
    //     _isPlaying = play.playing;
    //   });
    // });
    notifyListeners();
  }

  void togglePlayPause() async {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
    notifyListeners();
  }

  void stopPlayer() {
    _player.stop();
    _currentTitle = null;
    notifyListeners();
  }
}

class AnimateAudioPlayerWidget extends StatefulWidget {
  const AnimateAudioPlayerWidget({super.key, required this.isExpanded});
  final bool isExpanded;

  @override
  State<AnimateAudioPlayerWidget> createState() =>
      _AnimateAudioPlayerWidgetState();
}

class _AnimateAudioPlayerWidgetState extends State<AnimateAudioPlayerWidget> {
  void _toggle() => setState(() => _expanded = !_expanded);
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? MediaQuery.of(context).size.height : 60,
      // margin: const EdgeInsets.all(12),
      // padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: _toggle,
        child: _expanded ? const TestAudioPlayer() : const MiniAudioOverlay(),
      ),
    );
  }
}

class AudiobookListPage extends StatefulWidget {
  const AudiobookListPage({super.key});

  @override
  State<AudiobookListPage> createState() => _AudiobookListPageState();
}

class _AudiobookListPageState extends State<AudiobookListPage> {
  List<Map<String, String>> books = [];
  int page = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchMore();
  }

  Future<void> fetchMore() async {
    if (loading) return;
    setState(() => loading = true);

    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    books.addAll(List.generate(
        10,
        (i) => {
              'title': 'Audiobook ${(page - 1) * 10 + i + 1}',
              'url':
                  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
            }));

    setState(() {
      page++;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Audiobooks")),
      body: ChangeNotifierProvider(
        create: (_) => AudioManager(),
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!loading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  fetchMore();
                }
                return false;
              },
              child: SizedBox(
                height: 600,
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (_, index) {
                    final book = books[index];
                    return ListTile(
                      title: Text(book['title']!),
                      onTap: () {
                        AudioManager().play(book['title']!, book['url']!);
                        // AudioManager().updateData();
                      },
                    );
                  },
                ),
              ),
            ),
            Consumer<AudioManager>(
              builder: (context, audio, child) => Align(
                alignment: Alignment.bottomCenter,
                child: (!audio.isAudioAvailable)
                    ? const SizedBox.shrink()
                    : const AnimateAudioPlayerWidget(
                        isExpanded: false,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
