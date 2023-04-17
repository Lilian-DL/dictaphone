import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeModel extends ChangeNotifier {
  List<File> _audioList = [];
  bool _isRecordedReady = false;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  HomeModel() {
    initRecorder();
  }

  @override
  void dispose() {
    _recorder.stopRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granded';
    }
    await _recorder.openRecorder();

    _isRecordedReady = true;
    _recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  void onRecorder() async {
    if (_recorder.isRecording) {
      await stop();
    } else {
      await record();
    }
  }

  Future record() async {
    if (!isRecordedReady) return;
    await _recorder.startRecorder(toFile: 'audio${_audioList.length + 1}');
    notifyListeners();
  }

  Future stop() async {
    if (!isRecordedReady) return;
    final path = await _recorder.stopRecorder();
    if (path != null) {
      File audioFile = File(path);
      addAudioList(audioFile);
    }
    notifyListeners();
  }

  void addAudioList(File file) {
    _audioList.add(file);
    notifyListeners();
  }

  List<File> get audioList => _audioList;

  set audioList(List<File> value) {
    if (value != _audioList) {
      _audioList = value;
      notifyListeners();
    }
  }

  FlutterSoundRecorder get recorder => _recorder;

  bool get isRecordedReady => _isRecordedReady;
}
