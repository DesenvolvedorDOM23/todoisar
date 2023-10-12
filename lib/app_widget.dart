import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoisar/src/cubits/board_cubit.dart';
import 'package:todoisar/src/page/board_page.dart';
import 'package:todoisar/src/repositories/board_repositorie.dart';
import 'package:todoisar/src/repositories/isar/data/isar_datasource/isar_datasource.dart';
import 'package:todoisar/src/repositories/isar/isar_repositorie_board.dart/isar_board_repository.dart';

class AppWidget extends StatelessWidget {
  AppWidget();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (ctx) => IsarDatasource()),
        RepositoryProvider<BoardRepositorie>(
            create: (ctx) => IsarBoardRepository(ctx.read())),
        BlocProvider(create: (ctx) => Boardcubit(ctx.read()))
      ],
      child: MaterialApp(
        title: 'todoApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        home: const BoardPage(),
      ),
    );
  }
}
