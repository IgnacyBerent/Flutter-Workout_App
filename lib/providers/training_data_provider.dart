import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedData {
  String split;
  String date;

  SelectedData({required this.split, required this.date});
}

class SelectedDataNotifier extends StateNotifier<SelectedData> {
  SelectedDataNotifier() : super(SelectedData(split: '', date: ''));

  void changeSplit(String newSplit) {
    state = SelectedData(split: newSplit, date: state.date);
  }

  void changeDate(String newDate) {
    state = SelectedData(split: state.split, date: newDate);
  }
}

final selectedDataProvider =
    StateNotifierProvider<SelectedDataNotifier, SelectedData>(
        (ref) => SelectedDataNotifier());
