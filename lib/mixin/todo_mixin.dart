import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/todos/todo_bloc.dart';
import 'package:todo_app/model/todo_model.dart';

import '../widgets/show_snack_bar.dart';
import '../widgets/text_field_widget.dart';

mixin TodoMixin {
  final formkey = GlobalKey<FormState>();
  final taskController = TextEditingController();
  final descriptionController = TextEditingController();

  void trySubmitTodo(BuildContext context) {
    var todo = Todo(
      id: DateTime.now().toIso8601String(),
      task: taskController.text,
      description: descriptionController.text,
    );
    context.read<TodoBloc>().add(TodoAdded(todo: todo));
    Navigator.of(context).pop();
    taskController.clear();
    descriptionController.clear();
  }

  void addBottomeSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return BlocListener<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoLoadSuccess) {
              showSnackBar(
                context,
                'Task was successfully added!',
                Colors.greenAccent,
              );
            }
          },
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextFieldWidget(text: 'Task', controller: taskController),
                    const SizedBox(height: 5),
                    TextFieldWidget(
                        text: 'Description', controller: descriptionController),
                    const SizedBox(height: 5),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => trySubmitTodo(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text('Create'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
