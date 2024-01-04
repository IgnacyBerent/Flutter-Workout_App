import 'package:flutter/material.dart';
import 'package:workout_app/screens/new_training.dart';

class NewTrainingCard extends StatelessWidget {
  const NewTrainingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 80,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const NewTrainingScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Theme.of(context).colorScheme.onSecondary,
          child: Card(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
