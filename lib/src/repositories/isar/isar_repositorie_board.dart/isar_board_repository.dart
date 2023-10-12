

import 'package:todoisar/src/models/task_model.dart';
import 'package:todoisar/src/repositories/board_repositorie.dart';
import 'package:todoisar/src/repositories/isar/data/isar_datasource/isar_datasource.dart';
import 'package:todoisar/src/repositories/isar/model/task_model.dart';

class IsarBoardRepository implements BoardRepositorie {
  final IsarDatasource datasource;
  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> featch() async {
    final models = await datasource.getTasks();
    return models
        .map((e) => Task(id: e.id, description: e.description))
        .toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = tasks.map((e) {
      final model = TaskModel()
        ..check = e.check
        ..description = e.description;
      if (e.id != -1) {
        model.id = e.id;
      }
      return model;
    }).toList();
    await datasource.deleAllTasks();
    await datasource.putAllTasks(models);
    return tasks;
  }
}
