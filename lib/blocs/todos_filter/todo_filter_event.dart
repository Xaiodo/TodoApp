part of 'todo_filter_bloc.dart';

abstract class TodoFilterEvent extends Equatable {
  const TodoFilterEvent();

  @override
  List<Object> get props => [];
}

class TodoFilterUpdated extends TodoFilterEvent {
  const TodoFilterUpdated();

  @override
  List<Object> get props => [];
}

class TodosUpadeted extends TodoFilterEvent {
  final TodoFilter todoFilter;

  const TodosUpadeted({this.todoFilter = TodoFilter.all});

  @override
  List<Object> get props => [todoFilter];
}
