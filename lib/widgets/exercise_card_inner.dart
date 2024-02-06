import 'package:flutter/material.dart';

import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/screens/edit_training/edit_edit_exercise.dart';
import 'package:workout_app/screens/new_training/edit_exercise.dart';
import 'package:workout_app/widgets/exercise_card.dart';

class ExerciseCardInner extends StatelessWidget {
  const ExerciseCardInner(this.exercise, {super.key, this.edit = false});

  final Exercise exercise;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150,
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => edit
                      ? EditEditExercise(currentExercise: exercise)
                      : EditExercise(currentExercise: exercise),
                ),
              );
            },
            splashColor: Theme.of(context).colorScheme.onSecondary,
            child: ExerciseCard(exercise)),
      ),
    );
  }
}
