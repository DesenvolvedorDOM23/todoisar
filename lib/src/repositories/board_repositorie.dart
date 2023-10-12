

import 'package:todoisar/src/models/task_model.dart';

abstract class BoardRepositorie {
  Future<List<Task>> featch();
  Future<List<Task>> update(List<Task> tasks);
}
