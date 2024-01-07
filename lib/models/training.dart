// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
  final String date;
  final String split;
  final List<Exercise> exercises;

  Training({
    required this.date,
    required this.split,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'split': split.toString(),
      'exercises': exercises.map((x) => x.toMap()).toList(),
    };
  }

  factory Training.fromMap(Map<String, dynamic> map) {
    return Training(
      date: map['date'] as String,
      split: map['split'] as String,
      exercises: List<Exercise>.from(
        (map['exercises'] as List<int>).map<Exercise>(
          (x) => Exercise.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Training.fromJson(String source) =>
      Training.fromMap(json.decode(source) as Map<String, dynamic>);
}
