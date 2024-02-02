import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/animated_background_container.dart';
import 'package:workout_app/widgets/widget_tree.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:just_audio/just_audio.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SequenceAnimation _sequenceAnimation;

  _playSoundMultipleTimes() async {
    for (int i = 0; i < 4; i++) {
      await Future.delayed(Duration(milliseconds: 400 * i), () async {
        AudioPlayer player = AudioPlayer();
        if (i == 0) {
          await player.setAsset('assets/sounds/yeah_buddy.mp3');
        } else {
          await player.setAsset('assets/sounds/falling_pipe_line.mp3');
        }
        player.play();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 0.0, end: 1.0),
          from: const Duration(seconds: 0),
          to: const Duration(seconds: 5),
          tag: "opacity",
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0.3, end: 1.9),
          from: const Duration(seconds: 0),
          to: const Duration(seconds: 5),
          tag: "size",
        )
        .animate(_controller);

    _controller.forward();

    _playSoundMultipleTimes();

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 6), () {});

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WidgetTree()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackgroundContainer(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: _sequenceAnimation["opacity"].value,
                child: Transform.scale(
                  scale: _sequenceAnimation["size"].value,
                  child: child!,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientText(
                  'Are you ready?',
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  colors: [
                    Theme.of(context).colorScheme.onPrimaryContainer,
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary
                  ],
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    BlendMode.modulate,
                  ),
                  child: const Image(
                    image: AssetImage(
                      'assets/AppIconAlpha.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
