import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/models/exercise.dart';

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
  final DateTime date;
  final String split;
  final List<Exercise> exercises;

  Training({
    required this.date,
    required this.split,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.toIso8601String(),
      'split': split.toString(),
      'exercises': exercises,
    };
  }

  factory Training.fromMap(Map<String, dynamic> map) {
    return Training(
      date: DateTime.parse(map['date'] as String),
      split: map['split'] as String,
      exercises: List<Exercise>.from(
        (map['exercises'] as List<int>).map<Exercise>(
          (x) => Exercise.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  static Training fromSnapshot(DocumentSnapshot<Object?> doc) {
    return Training(
      date: DateTime.parse(doc['date'] as String),
      split: doc['split'] as String,
      exercises: [],
    );
  }

  String get formattedDate {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
