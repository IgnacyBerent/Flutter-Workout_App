import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/animated_background_container.dart';

import 'package:workout_app/firestore/auth.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/models/training.dart';
import 'package:workout_app/providers/new_exercises_provider.dart';
import 'package:workout_app/providers/training_data_provider.dart';
import 'package:workout_app/providers/trainings_provider.dart';
import 'package:workout_app/screens/new_training/exercises.dart';
import 'package:workout_app/widgets/exercise_card_outer.dart';

class NewTrainingScreen extends ConsumerStatefulWidget {
  const NewTrainingScreen({super.key});

  @override
  ConsumerState<NewTrainingScreen> createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends ConsumerState<NewTrainingScreen> {
  final GlobalKey<AnimatedBackgroundContainerState> animatedBackgroundKey =
      GlobalKey();
  final FireStoreClass _db = FireStoreClass();
  var _selectedSplit = 'I';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingLT = false;
  String _selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final User? user = Auth().currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedDataProvider.notifier).changeSplit(_selectedSplit);
      ref.read(selectedDataProvider.notifier).changeDate(_selectedDate);
    });
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
      ref.read(selectedDataProvider.notifier).changeDate(_selectedDate);
    });
  }

  Future<void> _fetchLastTraining() async {
    setState(() {
      _isLoadingLT = true;
    });
    final List<Exercise> lastTrainingExercises = await _db.getLastTraining(
        uid: user!.uid, split: _selectedSplit, date: _selectedDate);
    if (lastTrainingExercises.isNotEmpty) {
      ref.read(exercisesProvider.notifier).load(lastTrainingExercises);
      setState(() {
        _isLoadingLT = false;
      });
    } else {
      setState(() {
        _isLoadingLT = false;
      });
      if (!context.mounted) {
        return;
      }
      //show dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No last training found'),
          content: const Text('Please add exercises manually'),
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
    }
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
      date: DateFormat('dd-MM-yyyy').parse(_selectedDate),
      split: _selectedSplit,
      exercises: ref.read(exercisesProvider),
    );
    await _db.addTraining(
      uid: user!.uid,
      training: newTraining,
    );
    // get all custom exercises names (those which arent in exerciseImageMap.keys)
    final List<Map<String, String>> customExercises = [];
    for (Exercise exercise in ref.read(exercisesProvider)) {
      if (!exerciseImageMap.keys.contains(exercise.name)) {
        final Map<String, String> customExerciseMap = {
          exercise.name: exercise.bodyPart.toString()
        };
        customExercises.add(customExerciseMap);
      }
    }
    // add custom exercises to the firebase
    if (customExercises.isNotEmpty) {
      await _db.addCustomExercisesNames(
        uid: user!.uid,
        exercises: customExercises,
      );
    }

    ref.read(exercisesProvider.notifier).clear();
    ref.read(trainingsProvider.notifier).add(newTraining);

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final List<Exercise> addedExercises = ref.watch(exercisesProvider);

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
        title: const Text('New Training'),
      ),
      body: AnimatedBackgroundContainer(
        key: animatedBackgroundKey,
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
                            ref
                                .read(selectedDataProvider.notifier)
                                .changeSplit(_selectedSplit);
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
                    onPressed: _isLoadingLT || addedExercises.isNotEmpty
                        ? null
                        : _fetchLastTraining,
                    child: _isLoadingLT
                        ? const CircularProgressIndicator()
                        : const Text('Copy last training'),
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
        ),
      ),
    );
  }
}
