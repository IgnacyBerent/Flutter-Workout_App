import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:workout_app/animated_background_container.dart';
import 'package:workout_app/charts/exercise_progress_chart.dart';
import 'package:workout_app/firestore/auth.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/widgets/exercise_list_tile.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExerciseStatsScreen extends StatefulWidget {
  const ExerciseStatsScreen({super.key});

  @override
  State<ExerciseStatsScreen> createState() => _ExerciseStatsScreenState();
}

class _ExerciseStatsScreenState extends State<ExerciseStatsScreen> {
  final _exerciseNameController = TextEditingController();
  final _options = exerciseImageMap.keys.toList();
  var _isLoading = false;
  var exerciseChartName = '';
  final User? user = Auth().currentUser;
  final FireStoreClass _db = FireStoreClass();
  ExerciseProgressChart? chart;

  Future<void> _fetchExerciseRecords({
    required String exerciseName,
  }) async {
    final List<ExerciseProgress> exerciseRecords = await _db.getExerciseRecords(
      uid: user!.uid,
      exerciseName: exerciseName,
    );

    // sort the records by date
    exerciseRecords.sort((a, b) => a.time.compareTo(b.time));

    final seriesList = [
      LineSeries<ExerciseProgress, DateTime>(
        dataSource: exerciseRecords,
        xValueMapper: (record, _) => record.time,
        yValueMapper: (record, _) => record.oneRepMax,
      ),
    ];

    setState(() {
      chart = ExerciseProgressChart(seriesList, exerciseName);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _db.getCustomExericsesNames(uid: user!.uid).then((customExercisesNames) {
      setState(() {
        for (var exerciseMap in customExercisesNames) {
          _options.addAll(exerciseMap.keys);
        }
      });
    });
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Exercise Stats'),
      ),
      body: AnimatedBackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 120, 0, 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TypeAheadField(
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
                    );
                  },
                  itemBuilder: (context, value) => ExerciseListTile(
                    context: context,
                    value: value,
                  ),
                  onSelected: (value) {
                    _exerciseNameController.text = value.toString();
                  },
                ),
              ),
              const SizedBox(height: 20),
              // button which will generate the chart if the exercise name is valid
              ElevatedButton(
                onPressed: () {
                  if (_options.contains(_exerciseNameController.text)) {
                    setState(() {
                      _isLoading = true;
                      exerciseChartName = _exerciseNameController.text;
                    });
                    _exerciseNameController.clear();
                    // unfocus the text field
                    FocusScope.of(context).unfocus();
                    _fetchExerciseRecords(
                      exerciseName: exerciseChartName,
                    );
                  } else {
                    // show Dialog
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Exercise Not Found'),
                        content:
                            const Text('Please enter a valid exercise name'),
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
                },
                child: const Text('Generate Chart'),
              ),
              const SizedBox(height: 20),
              // chart
              _isLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : exerciseChartName.isNotEmpty
                      ? Expanded(
                          child: Center(
                            child: chart!,
                          ),
                        )
                      : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
