// exercise_list_tile.dart
import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise.dart';

class ExerciseListTile extends StatelessWidget {
  const ExerciseListTile(
      {super.key,
      required this.context,
      required this.value,
      required this.bodypart});

  final BuildContext context;
  final String value;
  final String bodypart;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          exerciseImageMap.containsKey(value)
              ? Image.asset(
                  // icon is in assets/exercise_icons
                  'assets/exercise_icons/${exerciseImageMap[value]}',
                  width: 30,
                  height: 30,
                  color: Theme.of(context).colorScheme.primary,
                )
              : Icon(
                  Icons.fitness_center,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Wrap(
              spacing: 10, // space between the texts
              children: [
                Text(value),
                Text(bodypart,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
