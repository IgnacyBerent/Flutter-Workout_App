import 'package:cloud_firestore/cloud_firestore.dart';
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
      'trainings': [],
    });
  }

  Future<void> addTraining({
    required String uid,
    required String training,
  }) async {
    await _myFireStore.collection('users').doc(uid).update({
      'trainings': FieldValue.arrayUnion(
          [training]), // Dodawanie nowego treningu do listy
    });
  }
}
