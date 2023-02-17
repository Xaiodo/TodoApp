import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/todos/todo_bloc.dart';
import 'package:todo_app/widgets/todo_widet.dart';

import '../blocs/todos_filter/todo_filter_bloc.dart';

class TodoBlocBuilder extends StatelessWidget {
  final String text;
  const TodoBlocBuilder({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoFilterBloc, TodoFilterState>(
      builder: (context, state) {
        if (state is TodoFilterLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TodoFilterLoaded) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.filteredTodos.length,
                  itemBuilder: (context, index) => TodoWidget(
                    todo: state.filteredTodos[index],
                  ),
                )
              ],
            ),
          );
        } else {
          return const Text(
            'Some error occured, it`s developer`s fault, you can call him',
          );
        }
      },
    );
  }
}
