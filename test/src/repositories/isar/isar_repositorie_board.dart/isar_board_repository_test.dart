import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoisar/src/models/task_model.dart';
import 'package:todoisar/src/repositories/isar/data/isar_datasource/isar_datasource.dart';
import 'package:todoisar/src/repositories/isar/isar_repositorie_board.dart/isar_board_repository.dart';
import 'package:todoisar/src/repositories/isar/model/task_model.dart';


class IsarDataSourceMock extends Mock implements IsarDatasource {}

void main() {
  late IsarDataSourceMock isarDatasource;
  late IsarBoardRepository repository;
  setUp(() {
    isarDatasource = IsarDataSourceMock();
    repository = IsarBoardRepository(isarDatasource);
  });

  group('featch tasks ', () {
    test('feacth tasks isar', () async {
      when(() => isarDatasource.getTasks())
          .thenAnswer((_) async => [TaskModel()..id = 1]);

      final tasks = await repository.featch();
      expect(tasks.length, 1);
    });
  });
  test('update', () async {
    when(() => isarDatasource.putAllTasks(any())).thenAnswer((_) async => []);
    when(() => isarDatasource.deleAllTasks()).thenAnswer((_) async => []);

    final tasks = await repository.update([
      const Task(id: -1, description: 'heloo'),
      const Task(id: 2, description: 'eai'),
    ]);
    expect(tasks.length, 2);
  });
}
