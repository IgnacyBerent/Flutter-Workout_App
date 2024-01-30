import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseRecord {
  double weight;
  int reps;
  double oneRepMax;

  ExerciseRecord({
    required this.weight,
    required this.reps,
    required this.oneRepMax,
  });

  factory ExerciseRecord.fromSnapshot(DocumentSnapshot<Object?> doc) {
    double weight = doc['weight'] as double;
    int reps = doc['reps'] as int;
    return ExerciseRecord(
      weight: weight,
      reps: reps,
      oneRepMax: weight * (1 + (reps / 30)),
    );
  }
}
