import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/models/exercise_base.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:workout_app/providers/new_exercises_provider.dart';

class NewExercise extends ConsumerStatefulWidget {
  const NewExercise({
    super.key,
  });

  @override
  ConsumerState<NewExercise> createState() => _NewExerciseState();
}

class _NewExerciseState extends ConsumerState<NewExercise> {
  final _options =
      ExerciseName.values.map((exercise) => exercise.name).toList();
  final _exerciseNameController = TextEditingController();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  var _selectedExerciseName = '';
  var _selectedWeight = 0.0;
  var _selectedReps = 0;
  var _selectedBonusReps = 0;

  void _addExercise() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final newExercise = Exercise(
        name: _selectedExerciseName,
        weight: _selectedWeight,
        reps: _selectedReps,
        bonusReps: _selectedBonusReps,
      );

      ref.read(exerciseProvider.notifier).add(newExercise);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('New Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TypeAheadField(
                suggestionsCallback: ((search) => _options
                    .where((option) =>
                        option.toLowerCase().contains(search.toLowerCase()))
                    .toList()),
                controller: _exerciseNameController,
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Exercise Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter exercise name';
                      }
                      return null;
                    },
                    onSaved: (value) => _selectedExerciseName = value!,
                  );
                },
                itemBuilder: (context, value) => ListTile(
                  title: Text(value.toString()),
                ),
                onSelected: (value) {
                  _exerciseNameController.text = value.toString();
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter valid weight';
                  }
                  return null;
                },
                onSaved: (value) => _selectedWeight = double.parse(value!),
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reps',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reps number';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter valid reps number';
                  }
                  return null;
                },
                onSaved: (value) => _selectedReps = int.parse(value!),
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '0',
                decoration: const InputDecoration(
                  labelText: 'Bonus Reps',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reps number';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Please enter valid reps number';
                  }
                  return null;
                },
                onSaved: (value) => _selectedBonusReps = int.parse(value!),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Previous'),
                      Text('Results'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: Text('Calculate One-Rep Max'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: Text('Predict One-Rep Max'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: Text('Check Progress'),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 120,
                height: 43,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          // Show loading animation when _isLoading is true
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        )
                      : Text(
                          'Add',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                  ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
