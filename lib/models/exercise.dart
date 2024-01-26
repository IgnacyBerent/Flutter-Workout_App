import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Exercise {
  final String id;
  final String name;
  final double weight;
  final int reps;
  final int bonusReps;

  Exercise._({
    required this.id,
    required this.name,
    required this.weight,
    required this.reps,
    required this.bonusReps,
  });

  factory Exercise({
    String id = "",
    required String name,
    required double weight,
    required int reps,
    required int bonusReps,
  }) {
    id = id == "" ? const Uuid().v4() : id;
    return Exercise._(
      id: id,
      name: name,
      weight: weight,
      reps: reps,
      bonusReps: bonusReps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'weight': weight,
      'reps': reps,
      'bonusReps': bonusReps,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      weight: map['weight'] as double,
      reps: map['reps'] as int,
      bonusReps: map['bonusReps'] as int,
    );
  }

  factory Exercise.fromSnapshot(DocumentSnapshot snapshot) {
    return Exercise(
      id: snapshot.id,
      name: snapshot['name'] as String,
      weight: snapshot['weight'] as double,
      reps: snapshot['reps'] as int,
      bonusReps: snapshot['bonusReps'] as int,
    );
  }
}

enum ExerciseName {
  BenchPress,
  Squat,
  Deadlift,
  DumbbellBenchPress,
  PullUps,
  DumbbellCurl,
  PushUps,
  SledLegPress,
  DumbbellShoulderPress,
  BentOverRow,
  InclineBenchPress,
  InclineDumbbellBenchPress,
  FrontSquat,
  Dips,
  LatPulldown,
  HexBarDeadlift,
  PowerClean,
  HipThrust,
  DumbbellLateralRaise,
  MilitaryPress,
  LegExtension,
  DumbbellRow,
  ChestPress,
  HammerCurl,
  SeatedCableRow,
  CleanAndJerk,
  HackSquat,
  Clean,
  EZBarCurl,
  MachineChestFly,
  LyingTricepExtension,
  MachineShoulderPress,
  DumbbellFly,
  LyingLegCurl,
  GobletSquat,
  PreacherCurl,
  DumbbellShrug,
  TricepRopePushdown,
  CleanAndPress,
  DumbbellTricepExtension,
  RackPull,
  VerticalLegPress,
  UprightRow,
  BodyweightSquat,
  BulgarianSplitSquat,
  InclineDumbbellCurl,
  MachineRow,
  ArnoldPress,
  HangClean,
  FloorPress,
  MuscleUps,
  BarbellLunge,
  DumbbellReverseFly,
  SeatedDipMachine,
  ChestSupportedDumbbellRow,
  OverheadSquat,
  HipAdduction,
  Thruster,
  PowerSnatch,
  SplitSquat,
  Crunches,
  DeclineDumbbellBenchPress,
  CloseGripLatPulldown,
  MachineReverseFly,
  OneArmCableBicepCurl,
  DumbbellCalfRaise,
  OneArmPushUps,
  BarbellGluteBridge,
  ReverseGripLatPulldown,
  SledPressCalfRaise,
  SingleLegSquat,
  SingleLegPress,
  DeficitDeadlift,
  DumbbellUprightRow,
  SafetyBarSquat,
  OneArmDumbbellPreacherCurl,
  CableReverseFly,
  BehindTheNeckPress,
  MachineLateralRaise,
  HandstandPushUps,
  BarbellHackSquat,
  SeatedDumbbellTricepExtension,
  BenchPull,
  LogPress,
  SplitJerk,
  SumoSquat,
  SnatchDeadlift,
  DumbbellSnatch,
  InclineHammerCurl,
  BarbellPullover,
  CableKickback,
  ReverseGripTricepPushdown,
  SpiderCurl,
  BodyweightCalfRaise,
  Lunge,
  HangingLegRaise,
  ShoulderPinPress,
  RussianTwist,
  DeclinePushUp,
  BenchDips,
  HangingKneeRaise,
  AbWheelRollout,
  CableHammerCurl,
  DumbbellReverseCurl,
  ZercherDeadlift,
  PikePushUp,
  DumbbellInclineYRaise,
  SmithMachineShrug,
  DumbbellCleanAndPress,
  GluteKickback,
  BehindTheBackDeadlift,
  ReverseHyperextension,
  OverheadCableCurl,
  JeffersonSquat,
  FloorHipAbduction,
  FloorHipExtension,
}
