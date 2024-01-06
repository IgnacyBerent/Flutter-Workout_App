import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/providers/new_exercises_provider.dart';
import 'package:workout_app/screens/new_training.dart';

class NewTrainingCard extends ConsumerWidget {
  const NewTrainingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 80,
        child: InkWell(
          onTap: () {
            ref.read(exerciseProvider.notifier).clear();
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
