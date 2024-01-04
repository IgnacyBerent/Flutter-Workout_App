import 'package:flutter/material.dart';
import 'package:workout_app/firestore/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/widgets/new_training_card.dart';
import 'package:workout_app/widgets/training_card.dart';

class TrainingsScreen extends StatelessWidget {
  TrainingsScreen({super.key});

  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Center(
          child: Column(
        children: [
          const NewTrainingCard(),
          Expanded(
            child: ListView.builder(
              itemCount: 9,
              itemBuilder: (context, index) {
                return TrainingCard();
              },
            ),
          ),
        ],
      )),
    );
  }
}
