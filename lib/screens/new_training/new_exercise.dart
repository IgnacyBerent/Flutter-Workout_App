import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:workout_app/animated_background_container.dart';

import 'package:workout_app/firestore/auth.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/global_functions/ask_for_body_part.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/providers/new_exercises_provider.dart';
import 'package:workout_app/screens/new_training/button_functions.dart';
import 'package:workout_app/widgets/exercise_list_tile.dart';
import 'package:workout_app/widgets/sound_elevated_button.dart';

class NewExercise extends ConsumerStatefulWidget {
  const NewExercise({
    super.key,
  });

  @override
  ConsumerState<NewExercise> createState() => _NewExerciseState();
}

class _NewExerciseState extends ConsumerState<NewExercise> {
  final _options = exerciseImageMap.keys.toList();
  final _customExerciseNameBodyPartMap = <String, String>{};

  final _exerciseNameController = TextEditingController();
  final _selectedWeightController = TextEditingController();
  final _selectedRepsController = TextEditingController();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  var _selectedExerciseName = '';
  var _selectedWeight = 0.0;
  var _selectedReps = 0;
  var _selectedBonusReps = 0;

  final User? user = Auth().currentUser;
  final FireStoreClass _db = FireStoreClass();

  @override
  void initState() {
    super.initState();
    _db.getCustomExericsesNames(uid: user!.uid).then((customExercisesNames) {
      setState(() {
        for (var exerciseMap in customExercisesNames) {
          _options.addAll(exerciseMap.keys);
          _customExerciseNameBodyPartMap.addAll(exerciseMap);
        }
      });
    });
  }

  void _addExercise() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      String bodyPart = '';

      if (!_options.contains(_selectedExerciseName)) {
        bodyPart = await askForBodyPart(context);
      } else if (_customExerciseNameBodyPartMap
          .containsKey(_selectedExerciseName)) {
        bodyPart = _customExerciseNameBodyPartMap[_selectedExerciseName]!;
      } else {
        bodyPart = exerciseBodypartMap[_selectedExerciseName]!;
      }

      final newExercise = Exercise(
        name: _selectedExerciseName,
        weight: _selectedWeight,
        reps: _selectedReps,
        bonusReps: _selectedBonusReps,
        bodyPart: bodyPart,
      );

      if (!context.mounted) return;

      ref.read(exercisesProvider.notifier).add(newExercise);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _selectedWeightController.dispose();
    _selectedRepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('New Exercise'),
      ),
      body: AnimatedBackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 120, 40, 10),
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
                  itemBuilder: (context, value) => ExerciseListTile(
                    context: context,
                    value: value,
                    bodypart: _customExerciseNameBodyPartMap.containsKey(value)
                        ? _customExerciseNameBodyPartMap[value]!
                        : exerciseBodypartMap[value]!,
                  ),
                  onSelected: (value) {
                    _exerciseNameController.text = value.toString();
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _selectedWeightController,
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
                        double.parse(value) < 0) {
                      return 'Please enter valid weight';
                    }
                    return null;
                  },
                  onSaved: (value) => _selectedWeight = double.parse(value!),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _selectedRepsController,
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
                  height: 50,
                  width: double.infinity,
                  child: SoundElevatedButton(
                    onPressed: () {
                      showPreviusResults(
                        context: context,
                        ref: ref,
                        uid: user!.uid,
                        exerciseName: _exerciseNameController.text,
                      );
                    },
                    child: const Text('Previous Results'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: SoundElevatedButton(
                    onPressed: () {
                      showOneRepMax(
                        context: context,
                        lift: double.parse(_selectedWeightController.text),
                        reps: int.parse(_selectedRepsController.text),
                      );
                    },
                    child: const Text('Calculate One-Rep Max'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: SoundElevatedButton(
                    onPressed: () {},
                    child: const Text('Predict One-Rep Max'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: SoundElevatedButton(
                    onPressed: () {},
                    child: const Text('Check Progress'),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
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
      ),
    );
  }
}
