import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/providers/new_exercises_provider.dart';
import 'package:workout_app/screens/new_exercise.dart';
import 'package:workout_app/widgets/exercise_card_inner.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    final _addedExercises = ref.watch(exerciseProvider);

    Widget content = const Center(
      child: Text('No exercises added yet!'),
    );

    if (_addedExercises.isNotEmpty) {
      content = ListView.builder(
        itemCount: _addedExercises.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_addedExercises[index].name),
            onDismissed: (direction) => ref
                .read(exerciseProvider.notifier)
                .remove(_addedExercises[index]),
            child: ExerciseCardInner(_addedExercises[index]),
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
                  builder: (ctx) => const NewExercise(),
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
