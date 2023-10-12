import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoisar/src/cubits/board_cubit.dart';
import 'package:todoisar/src/models/task_model.dart';
import 'package:todoisar/src/repositories/board_repositorie.dart';
import 'package:todoisar/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepositorie {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late Boardcubit cubit;

  setUp(() {
    repository = BoardRepositoryMock();
    cubit = Boardcubit(repository);
  });
  group('feacth tasks', () {
    test('should get tasks ', () async {
      when(
        () => repository.featch(),
      ).thenAnswer((_) async => [
            const Task(id: 4, description: 'eai', check: true),
          ]);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<loadingBoardState>(),
            isA<GettedTasksBoardState>(),
          ]));
      await cubit.feathTasks();
    });
    test('should return state error', () async {
      when(() => repository.featch()).thenThrow(Exception('error'));
      expect(
        cubit.stream,
        emitsInOrder([
          isA<loadingBoardState>(),
          isA<FailureBoardState>(),
        ]),
      );
      await cubit.feathTasks();
    });
  });

  group('add tasks', () {
    test('should add  tasks ', () async {
      when(
        () => repository.update(any()),
      ).thenAnswer((_) async => []);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTasksBoardState>(),
          ]));
      var taks = const Task(
        id: 1,
        description: 'eai',
      );
      await cubit.addTasks(taks);
      final state = cubit.state as GettedTasksBoardState;

      expect(state.tasks.length, 1);
      expect(state.tasks, [taks]);
    });
    test('should return state error', () async {
      when(() => repository.update(any())).thenThrow(Exception('error'));
      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );
      var taks = const Task(
        id: 1,
        description: 'eai',
      );
      await cubit.addTasks(taks);
    });
  });

  group('remove tasks', () {
    test('should remove tasks ', () async {
      when(
        () => repository.update(any()),
      ).thenAnswer((_) async => []);
      var task = const Task(
        id: 1,
        description: 'lasi',
      );
      cubit.addTask([task]);
      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTasksBoardState>(),
          ]));

      await cubit.removeTasks(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 0);
    });
    test('should return state error', () async {
      when(() => repository.featch()).thenThrow(Exception('error'));
      var task = const Task(
        id: 1,
        description: 'lasi',
      );
      cubit.addTask([task]);
      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );
      await cubit.removeTasks(task);
    });
  });

  group('check tasks', () {
    test('should checks tasks ', () async {
      when(
        () => repository.update(any()),
      ).thenAnswer((_) async => []);
      var task = const Task(
        id: 1,
        description: 'lasi',
      );
      cubit.addTask([task]);
      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);
      expect((cubit.state as GettedTasksBoardState).tasks.first.check, false);

      expect(
          cubit.stream,
          emitsInOrder([
            isA<GettedTasksBoardState>(),
          ]));

      await cubit.checkTask(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks.first.check, true);
    });
    test('should return state error', () async {
      when(() => repository.featch()).thenThrow(Exception('error'));
      var task = const Task(
        id: 1,
        description: 'lasi',
      );
      cubit.addTask([task]);
      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );
      await cubit.removeTasks(task);
    });
  });
}
