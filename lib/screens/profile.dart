import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:workout_app/charts/gradient_pie_chart.dart';

import 'package:workout_app/firestore/auth.dart';
import 'package:workout_app/models/exercise_record.dart';
import 'package:workout_app/models/piechartsampledata.dart';
import 'package:workout_app/providers/trainings_provider.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/screens/exercise_stats.dart';
import 'package:workout_app/widgets/record_table_row.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;
  final FireStoreClass _db = FireStoreClass();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trainingsProvider.notifier).clear();
    });
    Future<List<ExerciseRecord>> fetchRecords() async {
      final benchRecord =
          await _db.getRecord(uid: user!.uid, exerciseName: "Bench Press");
      final squatRecord =
          await _db.getRecord(uid: user!.uid, exerciseName: "Squat");
      final deadliftRecord =
          await _db.getRecord(uid: user!.uid, exerciseName: "Deadlift");

      return [benchRecord, squatRecord, deadliftRecord];
    }

    return FutureBuilder<List<ExerciseRecord>>(
      future: fetchRecords(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ExerciseRecord>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final benchRecord = snapshot.data![0];
          final squatRecord = snapshot.data![1];
          final deadliftRecord = snapshot.data![2];

          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 120, 15, 20),
            child: Center(
              child: Column(
                children: [
                  GradientText(
                    'Your Records',
                    style: const TextStyle(
                      fontSize: 26.0,
                    ),
                    colors: [
                      Theme.of(context).colorScheme.onPrimaryContainer,
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary
                    ],
                  ),
                  const SizedBox(height: 25),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      const TableRow(
                        children: [
                          Text('Exercise', style: TextStyle(fontSize: 18)),
                          Text('Weight', style: TextStyle(fontSize: 18)),
                          Text('Reps', style: TextStyle(fontSize: 18)),
                          Text('ORM', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const TableRow(
                        children: [
                          Divider(),
                          Divider(),
                          Divider(),
                          Divider(),
                        ],
                      ),
                      recordTableRow('Bench Press', benchRecord),
                      recordTableRow('Squat', squatRecord),
                      recordTableRow('Deadlift', deadliftRecord),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<ChartSampleData>>(
                      future: _db.getExerciseBodyPartData(user!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return GradientPieChart(snapshot.data!);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const ExerciseStatsScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Check Progress'),
                          SizedBox(width: 10),
                          Icon(Icons.show_chart),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
