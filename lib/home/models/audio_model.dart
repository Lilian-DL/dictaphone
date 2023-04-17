import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:audioplayers/audioplayers.dart' as player;

class AudioModel extends ChangeNotifier {
  late File _audio;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final player.AudioPlayer _audioPlayer = player.AudioPlayer();

  AudioModel(File file) {
    _audio = file;
    initAudioPlayer();
  }

  Future initAudioPlayer() async {
    setAudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == player.PlayerState.playing;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      _duration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });
  }

  Future setAudioPlayer() async {
    _audioPlayer.setReleaseMode(player.ReleaseMode.stop);
    _audioPlayer.setSourceUrl(audio.path);
    notifyListeners();
  }

  Future play() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    notifyListeners();
  }

  Future movePositionPlayer(Duration duration) async {
    await _audioPlayer.seek(duration);
    await _audioPlayer.resume();
    notifyListeners();
  }

  File get audio => _audio;
  set audio(File value) {
    if (value != _audio) {
      _audio = value;
      notifyListeners();
    }
  }

  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
}
