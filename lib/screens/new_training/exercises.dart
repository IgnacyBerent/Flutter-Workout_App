import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/animated_background_container.dart';

import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/providers/new_exercises_provider.dart';
import 'package:workout_app/screens/new_training/new_exercise.dart';
import 'package:workout_app/widgets/exercise_card_inner.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  void _removeExercise(Exercise exercise, int index) {
    ref.read(exercisesProvider.notifier).remove(exercise);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exercise removed.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            ref.read(exercisesProvider.notifier).addWithIndex(exercise, index);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addedExercises = ref.watch(exercisesProvider);

    Widget content = const Center(
      child: Text('No exercises added yet!'),
    );

    if (addedExercises.isNotEmpty) {
      content = ListView.builder(
        itemCount: addedExercises.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(addedExercises[index].id),
            onDismissed: (direction) =>
                _removeExercise(addedExercises[index], index),
            child: ExerciseCardInner(addedExercises[index]),
          );
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Exercises'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const NewExercise(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: AnimatedBackgroundContainer(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 60, 40, 20), child: content),
      ),
    );
  }
}
