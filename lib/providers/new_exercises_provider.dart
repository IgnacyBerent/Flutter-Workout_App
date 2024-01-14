import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/models/exercise.dart';

class ExercisesNotifier extends StateNotifier<List<Exercise>> {
  ExercisesNotifier() : super([]);

  void add(Exercise exercise) {
    state = [...state, exercise];
  }

  void load(List<Exercise> exercises) {
    state = exercises;
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

final exercisesProvider =
    StateNotifierProvider<ExercisesNotifier, List<Exercise>>(
        (ref) => ExercisesNotifier());
