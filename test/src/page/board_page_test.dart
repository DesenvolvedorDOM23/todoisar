import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todoisar/src/cubits/board_cubit.dart';
import 'package:todoisar/src/page/board_page.dart';
import 'package:todoisar/src/repositories/board_repositorie.dart';

class BoardrepositoryMock extends Mock implements BoardRepositorie {}

void main() {
  late BoardrepositoryMock repository = BoardrepositoryMock();
  late Boardcubit cubit;

  setUp(() {
    repository = BoardrepositoryMock();
    cubit = Boardcubit(repository);
  });
  testWidgets('board page with all tasks', (tester) async {
    when(() => repository.featch()).thenAnswer((invocation) async => []);
    await tester.pumpWidget(BlocProvider.value(
      value: cubit,
      child: const MaterialApp(
        home: BoardPage(),
      ),
    ));
    expect(find.byKey(const Key('EmpetyBoardState')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const Key('GettedTasksBoardState')), findsOneWidget);
  });

  testWidgets('board page with all failure state', (tester) async {
    when(() => repository.featch()).thenThrow(Exception('Error'));
    await tester.pumpWidget(BlocProvider.value(
      value: cubit,
      child: const MaterialApp(
        home: BoardPage(),
      ),
    ));
    expect(find.byKey(const Key('EmpetyBoardState')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const Key('FailureBoardState')), findsOneWidget);
  });
}
