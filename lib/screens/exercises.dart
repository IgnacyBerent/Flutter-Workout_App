import 'package:flutter/material.dart';
import 'package:workout_app/screens/new_exercise.dart';
import 'package:workout_app/widgets/exercise_card_inner.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return const ExerciseCardInner();
          },
        ),
      ),
    );
  }
}
