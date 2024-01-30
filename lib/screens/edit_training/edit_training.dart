import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/animated_background_container.dart';

import 'package:workout_app/firestore/auth.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/models/training.dart';
import 'package:workout_app/providers/edit_exercises_provider.dart';
import 'package:workout_app/providers/trainings_provider.dart';
import 'package:workout_app/screens/edit_training/editable_exercises.dart';
import 'package:workout_app/widgets/exercise_card_outer.dart';

class EditTrainingScreen extends ConsumerStatefulWidget {
  const EditTrainingScreen(
      {super.key, required this.split, required this.date});

  final String split;
  final String date;

  @override
  ConsumerState<EditTrainingScreen> createState() => _EditTrainingScreenState();
}

class _EditTrainingScreenState extends ConsumerState<EditTrainingScreen> {
  final FireStoreClass _db = FireStoreClass();
  var _selectedSplit = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedDate = '';
  final User? user = Auth().currentUser;

  @override
  void initState() {
    super.initState();
    _selectedSplit = widget.split;
    _selectedDate = widget.date;
  }

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

  Future<void> _deleteTraining() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove your training?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              ref.read(trainingsProvider.notifier).remove(widget.date);
              await _db.deleteTraining(
                uid: user!.uid,
                date: widget.date,
              );
              if (!context.mounted) {
                return;
              }
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _editTraining() async {
    // check if there is at least one exercise added
    if (ref.read(editExercisesProvider).isEmpty) {
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
      exercises: ref.watch(editExercisesProvider),
    );
    await _db.updateTraining(
      uid: user!.uid,
      date: widget.date,
      newDate: _selectedDate,
      training: newTraining,
    );
    // get all custom exercises names (those which arent in exerciseImageMap.keys)
    final List<String> customExercisesNames = [];
    for (Exercise exercise in ref.read(editExercisesProvider)) {
      if (!exerciseImageMap.keys.contains(exercise.name)) {
        customExercisesNames.add(exercise.name);
      }
    }
    // add custom exercises to the firebase
    await _db.addCustomExercisesNames(
      uid: user!.uid,
      exercisesNames: customExercisesNames,
    );
    ref.read(editExercisesProvider.notifier).clear();
    ref.read(trainingsProvider.notifier).update(widget.date, newTraining);

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final List<Exercise> addedExercises = ref.watch(editExercisesProvider);

    Widget content = const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('All exercises removed!'),
          SizedBox(height: 20),
          Text('Tap here to add exercises'),
        ],
      ),
    );

    if (addedExercises.isNotEmpty) {
      content = ListView.builder(
        itemCount: addedExercises.length,
        itemBuilder: (context, index) {
          return ExerciseCardOuter(addedExercises[index]);
        },
      );
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Your Training'),
          actions: [
            IconButton(
              onPressed: _deleteTraining,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: AnimatedBackgroundContainer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 120, 40, 20),
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
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const EditableExercisesScreen(),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: _isLoading ? null : _editTraining,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Edit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
