import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise.dart';

Future<String> askForBodyPart(BuildContext context) async {
  String? bodyPart;
  while (bodyPart == null) {
    bodyPart = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select body part'),
          children: BodyParts.values.map((BodyParts bodyPart) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, bodyPart.name.toString());
              },
              child: Text(bodyPart.name.toString()),
            );
          }).toList(),
        );
      },
    );
  }
  return bodyPart;
}
