import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/mixin/todo_mixin.dart';
import 'package:todo_app/widgets/todo_bloc_builder.dart';

import '../blocs/todos_filter/todo_filter_bloc.dart';
import '../model/todo_filter_model.dart';

class HomeScreen extends StatelessWidget with TodoMixin {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Todo app with BloC',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          actions: [
            IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () => addBottomeSheet(context),
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            onTap: (tabIndex) {
              switch (tabIndex) {
                case 0:
                  context.read<TodoFilterBloc>().add(
                        const TodosUpadeted(
                          todoFilter: TodoFilter.pending,
                        ),
                      );
                  break;
                case 1:
                  context.read<TodoFilterBloc>().add(
                        const TodosUpadeted(
                          todoFilter: TodoFilter.completed,
                        ),
                      );
                  break;
              }
            },
            tabs: const [
              Tab(
                icon: Icon(Icons.format_list_bulleted),
              ),
              Tab(
                icon: Icon(Icons.add_task_rounded),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TodoBlocBuilder(text: 'Tasks to do:'),
            TodoBlocBuilder(text: 'Completed tasks:'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addBottomeSheet(context);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
