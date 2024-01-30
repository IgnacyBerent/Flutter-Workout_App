import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/gradient_background_color.dart';

import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/providers/edit_exercises_provider.dart';
import 'package:workout_app/screens/edit_training/edit_new_exercise.dart';
import 'package:workout_app/widgets/exercise_card_inner.dart';

class EditableExercisesScreen extends ConsumerStatefulWidget {
  const EditableExercisesScreen({super.key});

  @override
  ConsumerState<EditableExercisesScreen> createState() =>
      _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<EditableExercisesScreen> {
  void _removeExercise(Exercise exercise, int index) {
    ref.read(editExercisesProvider.notifier).remove(exercise);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exercise removed.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            ref
                .read(editExercisesProvider.notifier)
                .addWithIndex(exercise, index);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Exercise> addedExercises = ref.watch(editExercisesProvider);

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
            child: ExerciseCardInner(addedExercises[index], edit: true),
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
                  builder: (ctx) => const EditNewExercise(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        decoration: gradientBackground(),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 60, 40, 20), child: content),
      ),
    );
  }
}
