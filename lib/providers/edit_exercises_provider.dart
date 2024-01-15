import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/models/exercise.dart';

class EditExercisesNotifier extends StateNotifier<List<Exercise>> {
  EditExercisesNotifier() : super([]);

  void load(List<Exercise> exercises) {
    state = exercises;
  }

  void add(Exercise exercise) {
    state = [...state, exercise];
  }

  void addWithIndex(Exercise exercise, int index) {
    state = [
      ...state.sublist(0, index),
      exercise,
      ...state.sublist(index),
    ];
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

final editExercisesProvider =
    StateNotifierProvider<EditExercisesNotifier, List<Exercise>>(
        (ref) => EditExercisesNotifier());
