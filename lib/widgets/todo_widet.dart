import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/widgets/show_snack_bar.dart';

import '../blocs/todos/todo_bloc.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  const TodoWidget({required this.todo, Key? key}) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoDeleted) {
          showSnackBar(
            context,
            'Task was successfully deleted',
            Theme.of(context).backgroundColor,
          );
        }
        if (state is TodoUpdate) {
          showSnackBar(
            context,
            'Task was successfully completed',
            Theme.of(context).primaryColor,
          );
        }
      },
      child: Dismissible(
        key: ValueKey(widget.todo.id),
        background: Container(
          color: Theme.of(context).primaryColor,
        ),
        secondaryBackground: Container(
          color: Colors.redAccent,
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            context.read<TodoBloc>().add(
                TodoUpdated(todo: widget.todo.copyWith(isCompleted: true)));
          } else if (direction == DismissDirection.endToStart) {
            context
                .read<TodoBloc>()
                .add(TodoDeleted(todo: widget.todo.copyWith(isDeleted: true)));
          }
        },
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: ExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 200),
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text(
                            widget.todo.task,
                          ),
                        );
                      },
                      body: ListTile(
                        title: Text(
                          widget.todo.description == ''
                              ? 'There are not any description .-.'
                              : widget.todo.description,
                        ),
                      ),
                      isExpanded: _expanded,
                      canTapOnHeader: true,
                    ),
                  ],
                  elevation: 4,
                  expandedHeaderPadding: const EdgeInsets.all(10),
                  expansionCallback: (panelIndex, isExpanded) {
                    _expanded = !_expanded;
                    setState(() {});
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
