// exercise_list_tile.dart
import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise.dart';

class ExerciseListTile extends StatelessWidget {
  const ExerciseListTile({
    super.key,
    required this.context,
    required this.value,
  });

  final BuildContext context;
  final String value;

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
                )
              : const Icon(
                  Icons.fitness_center,
                  size: 30,
                  color: Colors.black,
                ),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
