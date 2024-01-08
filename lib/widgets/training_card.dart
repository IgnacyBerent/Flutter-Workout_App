import 'package:flutter/material.dart';
import 'package:workout_app/models/training.dart';

class TrainingCard extends StatelessWidget {
  const TrainingCard(this.training, {super.key});

  final Training training;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 80,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          splashColor: Theme.of(context).colorScheme.onSecondary,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  training.split,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  training.date,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
