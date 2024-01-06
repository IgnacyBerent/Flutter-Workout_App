import 'package:workout_app/models/exercise_base.dart';

enum Split {
  I,
  II,
  III,
  IV,
  V,
  VI,
  VII,
}

class Training {
  Training({
    required this.date,
    required this.split,
    required this.exercises,
  });

  final String date;
  final Split split;
  final List<Exercise> exercises;
}
