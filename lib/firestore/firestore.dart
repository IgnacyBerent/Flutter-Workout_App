import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_app/models/exercise.dart';
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
        .doc(training.date) // use the training date as the document ID
        .set(newTraining);

    // Add each exercise as a new document in the 'exercises' subcollection
    for (Exercise exercise in exercises) {
      await _myFireStore
          .collection('users')
          .doc(uid)
          .collection('trainings')
          .doc(training.date)
          .collection('exercises')
          .doc(exercise.id) // generate a new document ID for each exercise
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
        .orderBy('date',
            descending: true) // Sort by the 'date' field in descending order
        .limit(10); // Limit to 10 documents at a time

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
    await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(date)
        .delete();
  }

  Future<void> updateTraining({
    required String uid,
    required String date,
    required String newDate,
    required Training training,
  }) async {
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
        .doc(newDate) // use the training date as the document ID
        .set(newTraining);

    // Add each exercise as a new document in the 'exercises' subcollection
    for (Exercise exercise in exercises) {
      await _myFireStore
          .collection('users')
          .doc(uid)
          .collection('trainings')
          .doc(newDate)
          .collection('exercises')
          .doc(exercise.id) // generate a new document ID for each exercise
          .set(exercise.toMap());
    }
  }

  Future<List<Exercise>> getExercises({
    required String uid,
    required String date,
  }) async {
    final QuerySnapshot querySnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(date)
        .collection('exercises')
        .get();

    final List<Exercise> exercises = querySnapshot.docs
        .map((doc) => Exercise.fromSnapshot(doc))
        .toList()
        .cast<Exercise>();

    return exercises;
  }
}
