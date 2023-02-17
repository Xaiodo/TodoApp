part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  final List<Todo> todos;
  const TodoState({required this.todos});

  TodoState get loading => TodoLoading(todos: todos);

  TodoState get updated => TodoUpdate(todos: todos);

  TodoState get deletedTodo => TodoDelete(todos: todos);

  TodoState get loadFailure => TodoLoadFailure(todos: todos);

  TodoState loaded({required List<Todo> todos}) =>
      TodoLoadSuccess(todos: todos);

  @override
  List<Object> get props => [todos];
}

class TodoLoading extends TodoState {
  const TodoLoading({required super.todos});
}

class TodoLoadSuccess extends TodoState {
  const TodoLoadSuccess({required super.todos});
}

class TodoLoadFailure extends TodoState {
  const TodoLoadFailure({required super.todos});
}

class TodoDelete extends TodoState {
  const TodoDelete({required super.todos});
}

class TodoUpdate extends TodoState {
  const TodoUpdate({required super.todos});
}
