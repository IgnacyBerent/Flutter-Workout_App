import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise_base.dart';
import 'package:workout_app/widgets/exercise_card.dart';

class ExerciseCardInner extends StatelessWidget {
  const ExerciseCardInner(this.exercise, {super.key});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 140,
        child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            splashColor: Theme.of(context).colorScheme.onSecondary,
            child: ExerciseCard(exercise)),
      ),
    );
  }
}
