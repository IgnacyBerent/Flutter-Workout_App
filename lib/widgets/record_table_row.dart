import 'package:flutter/material.dart';

TableRow recordTableRow(String exercise, List<double> record) {
  final weight = record[0];
  final reps = record[1];

  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(exercise, style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text('$weight', style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text('${reps.toInt()}', style: const TextStyle(fontSize: 18)),
      ),
    ],
  );
}
