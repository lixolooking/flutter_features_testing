import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum PlayerState { stopped, playing, paused }

class PlayerWidgetState extends State<PlayerWidget> {
  final String _fileLink = 'https://files.fm/down.php?i=sdukdaz5&n=audio_1.mp3';
  final bool _isLocal = false;
  final PlayerMode mode = PlayerMode.MEDIA_PLAYER;
  final Key _btnPlayKey = UniqueKey();

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;

  PlayerState _playerState = PlayerState.stopped;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));
  }

  // Future<int> _pause() async {
  //   final result = await _audioPlayer.pause();
  //   if (result == 1) setState(() => _playerState = PlayerState.paused);
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                child: Slider(
                  inactiveColor: Colors.green[100],
                  activeColor: Colors.green[400],                             
                  value: 0.4,
                  onChanged: (double value) {},
                ),
              ),
          ),
          Expanded (
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: FlatButton(
                      key: _btnPlayKey,
                      child: Icon(
                        Icons.skip_previous, 
                        color: Colors.white, 
                        size: (25.0)),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow, 
                        color: Colors.white, 
                        size: (50.0)),
                      onPressed: _onPlayPressed,
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      child: Icon(
                        Icons.skip_next, 
                        color: Colors.white, 
                        size: (25.0)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> _onPlayPressed() async {
    int result = 0;
    if (_isPlaying) {
      result = await _pause();
    } else {
      result = await _play();
    }
    return result;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;

    final result =
        await _audioPlayer.play(_fileLink, isLocal: _isLocal, position: playPosition);
    if (result == 1) {
      setState(() => _playerState = PlayerState.playing);
    } 

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = PlayerState.paused);
    }
    return result;
  }
}

class PlayerWidget extends StatefulWidget {
  @override
  PlayerWidgetState createState() => PlayerWidgetState();

}