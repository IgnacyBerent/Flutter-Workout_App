import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/charts/exercise_progress_chart.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/models/exercise_record.dart';
import 'package:workout_app/models/piechartsampledata.dart';
import 'package:workout_app/models/training.dart';

class FireStoreClass {
  final FirebaseFirestore _myFireStore = FirebaseFirestore.instance;

  Future<void> createNewUser({
    required String uid,
    required String weight,
    required String height,
  }) async {
    await _myFireStore.collection('users').doc(uid).set({
      'weight': weight,
      'height': height,
    });
  }

  Future<void> addTraining({
    required String uid,
    required Training training,
  }) async {
    Map<String, dynamic> newTraining = training.toMap();

    // Remove the exercises from the training map as we will add them separately
    List<Exercise> exercises = newTraining.remove('exercises');

    // Add the training document without the exercises
    await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(training.date.toIso8601String())
        .set(newTraining);

    // Add each exercise as a new document in the 'exercises' subcollection
    for (Exercise exercise in exercises) {
      await _myFireStore
          .collection('users')
          .doc(uid)
          .collection('trainings')
          .doc(training.date.toIso8601String())
          .collection('exercises')
          .doc(exercise.id)
          .set(exercise.toMap());
    }
  }

  // function that returns list trainings 10 at a time, if there are more trainings to load
  // it will return the last document from the previous query
  Future<QuerySnapshot> getTrainings({
    required String uid,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .orderBy('date', descending: true)
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final QuerySnapshot querySnapshot = await query.get();

    return querySnapshot;
  }

  Future<void> deleteTraining({
    required String uid,
    required String date,
  }) async {
    // Convert date to DateTime object
    final dateObject = DateFormat('dd-MM-yyyy').parse(date);

    // Get reference to the subcollection
    CollectionReference exercises = _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(dateObject.toIso8601String())
        .collection('exercises');

    // Delete all documents in the subcollection
    QuerySnapshot querySnapshot = await exercises.get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete the main document
    await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(dateObject.toIso8601String())
        .delete();
  }

  Future<void> updateTraining({
    required String uid,
    required String date,
    required String newDate,
    required Training training,
  }) async {
    // Convert date to DateTime object
    final parts2 = newDate.split('-');
    final newDateObject = DateTime(
        int.parse(parts2[2]), int.parse(parts2[1]), int.parse(parts2[0]));

    // Delete the old training
    await deleteTraining(uid: uid, date: date);

    Map<String, dynamic> newTraining = training.toMap();

    // Remove the exercises from the training map as we will add them separately
    List<Exercise> exercises = newTraining.remove('exercises');

    // Add the training document without the exercises
    await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(newDateObject
            .toIso8601String()) // use the training date as the document ID
        .set(newTraining);

    // Add each exercise as a new document in the 'exercises' subcollection
    for (Exercise exercise in exercises) {
      await _myFireStore
          .collection('users')
          .doc(uid)
          .collection('trainings')
          .doc(newDateObject.toIso8601String())
          .collection('exercises')
          .doc(exercise.id)
          .set(exercise.toMap());
    }
  }

  Future<List<Exercise>> getExercises({
    required String uid,
    required String date,
  }) async {
    // Convert date to DateTime object
    final parts = date.split('-');
    final dateObject =
        DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

    final QuerySnapshot querySnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(dateObject.toIso8601String())
        .collection('exercises')
        .get();

    final List<Exercise> exercises = querySnapshot.docs
        .map((doc) => Exercise.fromSnapshot(doc))
        .toList()
        .cast<Exercise>();

    return exercises;
  }

  Future<List<Exercise>> getLastTraining({
    required String uid,
    required String split,
    required String date,
  }) async {
    // Convert date to DateTime object
    final parts = date.split('-');
    final dateObject =
        DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

    final QuerySnapshot querySnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .where('split', isEqualTo: split)
        .where('date', isLessThan: dateObject.toIso8601String())
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    final trainingId = querySnapshot.docs.first.id;
    final exercisesCollection = _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(trainingId)
        .collection('exercises');
    final exercisesSnapshot = await exercisesCollection.get();
    final exercises = exercisesSnapshot.docs.map((doc) {
      return Exercise.fromSnapshot(doc);
    }).toList();

    return exercises;
  }

  Future<Exercise> getLastExerciseResults({
    required String uid,
    required String name,
    required String date,
    required String split,
  }) async {
    // Convert date to DateTime object
    final parts = date.split('-');
    final dateObject =
        DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

    final QuerySnapshot querySnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .where('split', isEqualTo: split)
        .where('date', isLessThan: dateObject.toIso8601String())
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return Exercise(
        id: '',
        name: name,
        weight: 0,
        reps: 0,
        bonusReps: 0,
        bodyPart: '',
      );
    }

    final trainingId = querySnapshot.docs.first.id;
    final exerciseQuerySnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(trainingId)
        .collection('exercises')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (exerciseQuerySnapshot.docs.isEmpty) {
      return Exercise(
        id: '',
        name: name,
        weight: 0,
        reps: 0,
        bonusReps: 0,
        bodyPart: '',
      );
    }

    final exerciseDoc = exerciseQuerySnapshot.docs.first;
    return Exercise(
      id: exerciseDoc.id,
      name: exerciseDoc['name'],
      weight: exerciseDoc['weight'],
      reps: exerciseDoc['reps'],
      bonusReps: exerciseDoc['bonusReps'],
      bodyPart: exerciseDoc['bodyPart'],
    );
  }

  Future<ExerciseRecord> getRecord({
    required String uid,
    required String exerciseName,
  }) async {
    final List<ExerciseProgress> exerciseRecords = await getExerciseRecords(
      uid: uid,
      exerciseName: exerciseName,
    );

    // check if there are any records
    if (exerciseRecords.isEmpty) {
      return ExerciseRecord(
        weight: 0,
        reps: 0,
        oneRepMax: 0,
      );
    }

    // find date when one rep max was the highest
    double maxOneRepMax = 0;
    DateTime? maxOneRepMaxDate;
    for (var exerciseRecord in exerciseRecords) {
      if (exerciseRecord.oneRepMax > maxOneRepMax) {
        maxOneRepMax = exerciseRecord.oneRepMax;
        maxOneRepMaxDate = exerciseRecord.time;
      }
    } // fetch the exercise reps and weight for the date when one rep max was the highest
    final QuerySnapshot querySnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(maxOneRepMaxDate!
            .toIso8601String()) // Removed the null check here because we're already checking it above
        .collection('exercises')
        .where('name', isEqualTo: exerciseName)
        .get();

    final exerciseDoc = querySnapshot.docs.first;
    final ExerciseRecord record = ExerciseRecord.fromSnapshot(exerciseDoc);

    return record;
  }

  Future<void> addCustomExercisesNames({
    required String uid,
    required List<Map<String, String>> exercises,
  }) async {
    // Get the current custom exercises
    final currentCustomExercises = await getCustomExericsesNames(
      uid: uid,
    );

    // Add the new exercises to the current ones
    currentCustomExercises.addAll(exercises);

    // Remove duplicates
    final uniqueCustomExercises = currentCustomExercises
        .fold<List<Map<String, String>>>([], (previous, element) {
      if (!previous.any((map) => mapEquals(map, element))) {
        previous.add(element);
      }
      return previous;
    });

    // Update the custom exercises
    await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('customExercisesNames')
        .doc('customExercisesNames')
        .set({'exercises': uniqueCustomExercises});
  }

  Future<List<Map<String, String>>> getCustomExericsesNames({
    required String uid,
  }) async {
    // Get the current custom exercises
    final DocumentSnapshot doc = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('customExercisesNames')
        .doc('customExercisesNames')
        .get();

    if (!doc.exists) {
      return [];
    }

    final List<Map<String, String>> currentCustomExercises =
        (doc['exercises'] as List)
            .map((item) => Map<String, String>.from(item))
            .toList();

    return currentCustomExercises;
  }

  Future<void> deleteCustomExerciseName({
    required String uid,
    required String exerciseName,
  }) async {
    // Get the current custom exercises
    final currentCustomExercises = await getCustomExericsesNames(
      uid: uid,
    );

    // Find the exercise to remove
    final exerciseToRemove = currentCustomExercises.firstWhere(
      (exercise) => exercise['name'] == exerciseName,
      orElse: () => {},
    );

    // Remove the exercise from the current ones
    currentCustomExercises.remove(exerciseToRemove);

    // Update the custom exercises
    await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('customExercisesNames')
        .doc('customExercisesNames')
        .set({'exercises': currentCustomExercises});
  }

  Future<List<ExerciseProgress>> getExerciseRecords({
    required String uid,
    required String exerciseName,
  }) async {
    final QuerySnapshot trainingsSnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .get();

    final List<ExerciseProgress> exerciseRecords = [];

    // Create a list of futures for each 'training' document
    final futures = trainingsSnapshot.docs.map((training) async {
      final exercisesSnapshot = await _myFireStore
          .collection('users')
          .doc(uid)
          .collection('trainings')
          .doc(training.id)
          .collection('exercises')
          .where('name', isEqualTo: exerciseName)
          .get();

      for (var exercise in exercisesSnapshot.docs) {
        final weight = exercise['weight'];
        final reps = exercise['reps'];
        final oneRepMax = weight * (1 + (reps / 30));
        final trainingDate = DateTime.parse(training.id);
        exerciseRecords.add(ExerciseProgress(trainingDate, oneRepMax));
      }
    });

    // Wait for all futures to complete
    await Future.wait(futures);
    return exerciseRecords;
  }

  Future<List<ChartSampleData>> getExerciseBodyPartData(String uid) async {
    List<ChartSampleData> data = [];

    var i = 0;
    for (BodyParts part in BodyParts.values) {
      final QuerySnapshot trainingsSnapshot = await _myFireStore
          .collection('users')
          .doc(uid)
          .collection('trainings')
          .get();

      int count = 0;
      for (var training in trainingsSnapshot.docs) {
        final QuerySnapshot exercisesSnapshot = await _myFireStore
            .collection('users')
            .doc(uid)
            .collection('trainings')
            .doc(training.id)
            .collection('exercises')
            .where('bodyPart', isEqualTo: part.name.toString())
            .get();
        count += exercisesSnapshot.docs.length;
      }

      data.add(ChartSampleData(
        index: i++,
        x: part.toString().split('.').last,
        y: count.toDouble(),
      ));
    }

    return data;
  }
}
