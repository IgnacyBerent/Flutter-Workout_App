import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/widgets/exercise_card.dart';

class ExerciseCardOuter extends StatelessWidget {
  const ExerciseCardOuter(this.exercise, {super.key});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 140,
        child: ExerciseCard(exercise),
      ),
    );
  }
}
