import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  Widget build(BuildContext context) {
    final List<Exercise> _addedExercises = ref.watch(editExercisesProvider);

    Widget content = const Center(
      child: Text('No exercises added yet!'),
    );

    if (_addedExercises.isNotEmpty) {
      content = ListView.builder(
        itemCount: _addedExercises.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_addedExercises[index].id),
            onDismissed: (direction) => ref
                .read(editExercisesProvider.notifier)
                .remove(_addedExercises[index]),
            child: ExerciseCardInner(_addedExercises[index], edit: true),
          );
        },
      );
    }

    return Scaffold(
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
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: content),
    );
  }
}
