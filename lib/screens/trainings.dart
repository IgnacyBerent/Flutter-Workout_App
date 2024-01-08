import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/firestore/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/firestore/firestore.dart';
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
  final List<DocumentSnapshot> _trainingSnapshots = [];
  DocumentSnapshot? _lastDocument;
  final FireStoreClass _db = FireStoreClass();

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
    final QuerySnapshot querySnapshot = await _db.getTrainings(
      uid: user!.uid,
      lastDocument: _lastDocument,
    );

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
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return TrainingCard(snapshot.data!);
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
