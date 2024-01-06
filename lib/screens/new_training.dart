import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise_base.dart';
import 'package:workout_app/models/training.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/screens/exercises.dart';
import 'package:workout_app/widgets/exercise_card_outer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/providers/new_exercises_provider.dart';

class NewTrainingScreen extends ConsumerStatefulWidget {
  const NewTrainingScreen({super.key});

  @override
  ConsumerState<NewTrainingScreen> createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends ConsumerState<NewTrainingScreen> {
  var _selectedSplit = Split.I;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _addedExercises = ref.watch(exerciseProvider);

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
                                  value: split,
                                  child: Text(split.toString().split('.')[1]),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Split Day',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedSplit = value as Split;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        initialValue:
                            DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        decoration: const InputDecoration(
                          labelText: 'Date:  (DD-MM-YYYY)',
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
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
