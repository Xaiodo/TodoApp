import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/blocs/todos/todo_bloc.dart';

import '../../model/todo_filter_model.dart';
import '../../model/todo_model.dart';

part 'todo_filter_event.dart';
part 'todo_filter_state.dart';

class TodoFilterBloc extends Bloc<TodoFilterEvent, TodoFilterState> {
  final TodoBloc _todoBloc;
  late final StreamSubscription _todoSubcription;

  TodoFilterBloc({required TodoBloc todoBloc})
      : _todoBloc = todoBloc,
        super(TodoFilterLoading()) {
    on<TodoFilterUpdated>(_onUpdateFilter);
    on<TodosUpadeted>(_onUpdateTodos);

    _todoSubcription = todoBloc.stream.listen((state) {
      add(
        const TodoFilterUpdated(),
      );
    });
  }

  void _onUpdateFilter(TodoFilterUpdated event, Emitter<TodoFilterState> emit) {
    if (state is TodoFilterLoading) {
      add(
        const TodosUpadeted(todoFilter: TodoFilter.pending),
      );
    }

    if (state is TodoFilterLoaded) {
      final state = this.state as TodoFilterLoaded;

      add(
        TodosUpadeted(todoFilter: state.todoFilter),
      );
    }
  }

  void _onUpdateTodos(TodosUpadeted event, Emitter<TodoFilterState> emit) {
    final state = _todoBloc.state;

    if (state is TodoLoadSuccess) {
      List<Todo> todos = state.todos.where((todo) {
        switch (event.todoFilter) {
          case TodoFilter.all:
            return true;
          case TodoFilter.completed:
            return todo.isCompleted!;
          case TodoFilter.deleted:
            return todo.isDeleted!;
          case TodoFilter.pending:
            return !(todo.isCompleted! || todo.isDeleted!);
        }
      }).toList();

      emit(
        TodoFilterLoaded(
          filteredTodos: todos,
          todoFilter: event.todoFilter,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _todoSubcription.cancel();
    return super.close();
  }
}
