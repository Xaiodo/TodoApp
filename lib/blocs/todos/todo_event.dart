part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class TodoLoaded extends TodoEvent {
  const TodoLoaded();

  @override
  List<Object> get props => [];
}

class TodoAdded extends TodoEvent {
  final Todo todo;

  const TodoAdded({required this.todo});

  @override
  List<Object> get props => [todo];
}

class TodoUpdated extends TodoEvent {
  final Todo todo;

  const TodoUpdated({required this.todo});
  @override
  List<Object> get props => [todo];
}

class TodoDeleted extends TodoEvent {
  final Todo todo;

  const TodoDeleted({required this.todo});
  @override
  List<Object> get props => [todo];
}
