import 'package:flutter/material.dart';
import 'package:workout_app/models/training.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/screens/exercises.dart';
import 'package:workout_app/widgets/exercise_card_outer.dart';

class NewTrainingScreen extends StatefulWidget {
  const NewTrainingScreen({super.key});

  @override
  State<NewTrainingScreen> createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends State<NewTrainingScreen> {
  var _selectedSplit = Split.I;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Training'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Form(
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
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return const ExerciseCardOuter();
                      },
                    ),
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
