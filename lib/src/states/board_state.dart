

import 'package:todoisar/src/models/task_model.dart';

sealed class BoardState {}

class loadingBoardState implements BoardState {}

class GettedTasksBoardState implements BoardState {
  final List<Task> tasks;
  GettedTasksBoardState({required this.tasks});
}

class EmpetyBoardState extends GettedTasksBoardState {
  EmpetyBoardState() : super(tasks: []);
}

class FailureBoardState implements BoardState {
  final String message;
  FailureBoardState({required this.message});
}
