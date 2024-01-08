import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/firestore/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/models/training.dart';
import 'package:workout_app/widgets/new_training_card.dart';
import 'package:workout_app/widgets/training_card.dart';

class TrainingsScreen extends StatefulWidget {
  const TrainingsScreen({super.key});

  @override
  State<TrainingsScreen> createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends State<TrainingsScreen> {
  final User? user = Auth().currentUser;
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _trainingSnapshots = [];
  DocumentSnapshot? _lastDocument;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMoreData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    Query query = _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('trainings')
        .orderBy('date',
            descending: true) // Sort by the 'date' field in descending order
        .limit(10); // Limit to 10 documents at a time

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _trainingSnapshots.addAll(querySnapshot.docs);
        _lastDocument = querySnapshot.docs.last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Center(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _trainingSnapshots.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const NewTrainingCard();
            } else {
              final DocumentSnapshot<Object?> trainingSnapshot =
                  _trainingSnapshots[index - 1];
              if (trainingSnapshot.data() != null) {
                return FutureBuilder<Training>(
                  future: Training.fromSnapshot(trainingSnapshot),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading spinner while waiting
                    } else if (snapshot.hasError) {
                      return Text(
                          'Error: ${snapshot.error}'); // Show error message if there's an error
                    } else {
                      return TrainingCard(snapshot
                          .data!); // Show the TrainingCard when data is loaded
                    }
                  },
                );
              } else {
                return const SizedBox();
              }
            }
          },
        ),
      ),
    );
  }
}
