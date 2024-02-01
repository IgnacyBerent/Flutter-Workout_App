import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void playSound() {
  final player = AudioPlayer();
  player.play(AssetSource('falling_pipe_line.mp3'));
}

class SoundElevatedButton extends ElevatedButton {
  SoundElevatedButton({
    super.key,
    required Widget child,
    required VoidCallback onPressed,
  }) : super(
          child: child,
          onPressed: () {
            playSound();
            onPressed();
          },
        );
}
