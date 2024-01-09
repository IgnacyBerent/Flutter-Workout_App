import 'package:workout_app/firestore/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/models/training.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/screens/new_training/exercises.dart';
import 'package:workout_app/widgets/exercise_card_outer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/providers/new_exercises_provider.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/providers/trainings_provider.dart';

class NewTrainingScreen extends ConsumerStatefulWidget {
  const NewTrainingScreen({super.key});

  @override
  ConsumerState<NewTrainingScreen> createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends ConsumerState<NewTrainingScreen> {
  final FireStoreClass _db = FireStoreClass();
  var _selectedSplit = 'I';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final User? user = Auth().currentUser;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate!);
    });
  }

  Future<void> _saveTraining() async {
    // check if there is at least one exercise added
    if (ref.read(exercisesProvider).isEmpty) {
      //show dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No exercises added'),
          content: const Text('Please add at least one exercise'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final newTraining = Training(
      date: _selectedDate,
      split: _selectedSplit,
      exercises: ref.read(exercisesProvider),
    );
    await _db.addTraining(
      uid: user!.uid,
      training: newTraining,
    );
    ref.read(exercisesProvider.notifier).clear();
    ref.read(trainingsProvider.notifier).add(newTraining);

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final List<Exercise> _addedExercises = ref.watch(exercisesProvider);

    Widget content = const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No exercises added yet!'),
          SizedBox(height: 20),
          Text('Tap here to add exercises'),
        ],
      ),
    );

    if (_addedExercises.isNotEmpty) {
      content = ListView.builder(
        itemCount: _addedExercises.length,
        itemBuilder: (context, index) {
          return ExerciseCardOuter(_addedExercises[index]);
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('New Training'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 80,
                      child: DropdownButtonFormField(
                        value: _selectedSplit,
                        items: Split.values
                            .map((split) => DropdownMenuItem(
                                  value: split.toString().split('.')[1],
                                  child: Text(split.toString().split('.')[1]),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Split Day',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedSplit = value as String;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController()
                          ..text =
                              _selectedDate, // show the selected date in the text field
                        onTap: _presentDatePicker,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Copy last training'),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const ExercisesScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Theme.of(context).colorScheme.onSecondary,
                    child: content,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    onPressed: _isLoading ? null : _saveTraining,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
