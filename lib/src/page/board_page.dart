import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoisar/src/cubits/board_cubit.dart';
import 'package:todoisar/src/models/task_model.dart';
import 'package:todoisar/src/states/board_state.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<Boardcubit>().feathTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<Boardcubit>();
    final state = cubit.state;
    Widget body = Container();
    if (state is EmpetyBoardState) {
      body = const Center(
        key: Key('EmpetyBoardState'),
        child: Text('Adicione uma nova Task'),
      );
    } else if (state is GettedTasksBoardState) {
      final tasks = state.tasks;
      body = ListView.builder(
          key: const Key('GettedTasksBoardState'),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return GestureDetector(
              onLongPress: () {
                cubit.removeTasks(task);
              },
              child: CheckboxListTile(
                value: task.check,
                title: Text(task.description),
                onChanged: (value) {
                  cubit.checkTask(task);
                },
              ),
            );
          });
    } else if (state is FailureBoardState) {
      body = const Center(
        key: Key('FailureBoardState'),
        child: Text('falha ao pegar as tasks'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          alertDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void alertDialog() {
    var description = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Sair'),
            ),
            TextButton(
                onPressed: () {
                  final task = Task(id: -1, description: description);
                  context.read<Boardcubit>().addTasks(task);
                  Navigator.pop(context);
                },
                child: const Text('criar'))
          ],
          title: const Text('Adicionar uma task'),
          content: TextField(
            onChanged: (value) => description = value,
          ),
        );
      },
    );
  }
}
