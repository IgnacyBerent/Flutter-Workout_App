import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/models/training.dart';

class TrainingsNotifier extends StateNotifier<List<Training>> {
  TrainingsNotifier() : super([]);

  void load(List<Training> trainings) {
    state = [...state, ...trainings];
  }

  void add(Training training) {
    state = [training, ...state];
  }

  void remove(Training training) {
    state = state.where((e) => e != training).toList();
  }

  void update(Training editedTraining, Training training) {
    state = [
      for (final e in state)
        if (e == training) editedTraining else e
    ];
  }

  void clear() {
    state = [];
  }
}

final trainingsProvider =
    StateNotifierProvider<TrainingsNotifier, List<Training>>(
        (ref) => TrainingsNotifier());
