import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise_record.dart';

TableRow recordTableRow(String exercise, ExerciseRecord record) {
  final weight = record.weight;
  final reps = record.reps;
  final orm = record.oneRepMax.round();

  return TableRow(
    children: [
      Text(exercise, style: const TextStyle(fontSize: 16)),
      Text('$weight', style: const TextStyle(fontSize: 16)),
      Text('$reps', style: const TextStyle(fontSize: 16)),
      Text('$orm', style: const TextStyle(fontSize: 16)),
    ],
  );
}
