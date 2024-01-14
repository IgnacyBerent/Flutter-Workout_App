import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/firestore/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/models/training.dart';
import 'package:workout_app/widgets/new_training_card.dart';
import 'package:workout_app/widgets/training_card.dart';
import 'package:workout_app/providers/trainings_provider.dart';

class TrainingsScreen extends ConsumerStatefulWidget {
  const TrainingsScreen({super.key});

  @override
  ConsumerState<TrainingsScreen> createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends ConsumerState<TrainingsScreen> {
  final User? user = Auth().currentUser;
  final ScrollController _scrollController = ScrollController();
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
    final List<Training> loadedTrainings = querySnapshot.docs
        .map((doc) => Training.fromSnapshot(doc))
        .toList()
        .cast<Training>();

    ref.read(trainingsProvider.notifier).load(loadedTrainings);

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _lastDocument = querySnapshot.docs.last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainings = ref.watch(trainingsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Center(
        child: ListView.builder(
          controller: _scrollController,
          // Replace _trainingSnapshots with the list of trainings from TrainingsProvider
          itemCount: trainings.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const NewTrainingCard();
            } else {
              // Replace DocumentSnapshot with Training
              final Training training = trainings[index - 1];
              return TrainingCard(split: training.split, date: training.date);
            }
          },
        ),
      ),
    );
  }
}
