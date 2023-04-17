import 'package:dictaphone/home/models/audio_model.dart';
import 'package:dictaphone/home/models/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeModel(),
      child: Consumer<HomeModel>(
        builder: (context, homeModel, child) => Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            title: Center(
              child: Text(widget.title),
            ),
          ),
          body: Visibility(
            visible: !homeModel.recorder.isRecording,
            replacement: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: StreamBuilder<RecordingDisposition>(
                      stream: homeModel.recorder.onProgress,
                      builder: (context, snapshot) {
                        final duration = snapshot.hasData
                            ? snapshot.data!.duration
                            : Duration.zero;
                        return Text(
                          "${duration.inSeconds}'s",
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                      height: 300,
                      child: LottieBuilder.asset('assets/recorder.json')),
                ],
              ),
            ),
            child: Visibility(
              visible: homeModel.audioList.isNotEmpty,
              replacement: Center(
                child: SizedBox(
                  height: 300,
                  child: LottieBuilder.asset('assets/no-data.json'),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: homeModel.audioList.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider(
                          create: (_) => AudioModel(homeModel.audioList[index]),
                          child: Consumer<AudioModel>(
                            builder: (context, audioModel, child) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            child: IconButton(
                                              icon: Icon(
                                                audioModel.isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                              ),
                                              onPressed: () =>
                                                  audioModel.play(),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Audio ${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Slider(
                                        min: 0,
                                        max: audioModel.duration.inSeconds
                                            .toDouble(),
                                        value: audioModel.position.inSeconds
                                            .toDouble(),
                                        onChanged: (value) => audioModel
                                            .movePositionPlayer(Duration(
                                                seconds: value.toInt())),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              audioModel.position
                                                  .toString()
                                                  .substring(0, 10),
                                            ),
                                            Text(
                                              audioModel.duration
                                                  .toString()
                                                  .substring(0, 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => homeModel.onRecorder(),
            tooltip: 'Increment',
            child:
                Icon(homeModel.recorder.isRecording ? Icons.stop : Icons.mic),
          ),
        ),
      ),
    );
  }
}
