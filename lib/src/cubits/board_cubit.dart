import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoisar/src/models/task_model.dart';
import 'package:todoisar/src/repositories/board_repositorie.dart';
import 'package:todoisar/src/states/board_state.dart';

class Boardcubit extends Cubit<BoardState> {
  final BoardRepositorie repositorie;
  Boardcubit(this.repositorie) : super(EmpetyBoardState());

  Future<void> feathTasks() async {
    emit(loadingBoardState());
    try {
      final tasks = await repositorie.featch();
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error in getted tasks'));
    }
  }

  Future<void> addTasks(Task newtask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.add(newtask);
    emitTasks(tasks);
  }

  Future<void> removeTasks(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.remove(newTask);
    emitTasks(tasks);
    print('remove task');
  }

  Future<void> checkTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);
    emitTasks(tasks);
  }

  @visibleForTesting
  void addTask(List<Task> tasks) {
    emit(GettedTasksBoardState(tasks: tasks));
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! GettedTasksBoardState) {
      return null;
    }
    return state.tasks.toList();
  }

  Future<void> emitTasks(List<Task> tasks) async {
    try {
      await repositorie.update(tasks);
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Erro ao remover tasks'));
    }
  }
}
