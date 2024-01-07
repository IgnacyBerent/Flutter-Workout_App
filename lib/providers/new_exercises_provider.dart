import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/models/exercise_base.dart';

class ExerciseNotifier extends StateNotifier<List<Exercise>> {
  ExerciseNotifier() : super([]);

  void add(Exercise exercise) {
    state = [...state, exercise];
  }

  void remove(Exercise exercise) {
    state = state.where((e) => e != exercise).toList();
  }

  void update(Exercise editedExercise, Exercise exercise) {
    state = [
      for (final e in state)
        if (e == exercise) editedExercise else e
    ];
  }

  void clear() {
    state = [];
  }
}

final exerciseProvider =
    StateNotifierProvider<ExerciseNotifier, List<Exercise>>(
        (ref) => ExerciseNotifier());
