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
    // Get reference to the subcollection
    CollectionReference exercises = _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .doc(date)
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

  // searches for training with the same split and date closest to the given
  Future<List<Exercise>> getLastTraining({
    required String uid,
    required String split,
    required String date,
  }) async {
    final QuerySnapshot querySnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .where('split', isEqualTo: split)
        .where('date', isLessThan: date)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    final trainingId = querySnapshot.docs.first.id;
    final exercisesCollection = FirebaseFirestore.instance
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

  // search for exercise results from the last training with the same name
  Future<Exercise> getLastExerciseResults({
    required String uid,
    required String name,
    required String date,
    required String split,
  }) async {
    final QuerySnapshot querySnapshot = await _myFireStore
        .collection('users')
        .doc(uid)
        .collection('trainings')
        .where('split', isEqualTo: split)
        .where('date', isLessThan: date)
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
      );
    }

    final trainingId = querySnapshot.docs.first.id;
    final exerciseQuerySnapshot = await FirebaseFirestore.instance
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
      );
    }

    final exerciseDoc = exerciseQuerySnapshot.docs.first;
    return Exercise(
      id: exerciseDoc.id,
      name: exerciseDoc['name'],
      weight: exerciseDoc['weight'],
      reps: exerciseDoc['reps'],
      bonusReps: exerciseDoc['bonusReps'],
    );
  }
}
