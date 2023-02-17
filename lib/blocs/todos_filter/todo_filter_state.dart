part of 'todo_filter_bloc.dart';

abstract class TodoFilterState extends Equatable {
  const TodoFilterState();

  @override
  List<Object> get props => [];
}

class TodoFilterLoading extends TodoFilterState {}

class TodoFilterLoaded extends TodoFilterState {
  final List<Todo> filteredTodos;
  final TodoFilter todoFilter;

  const TodoFilterLoaded({
    required this.filteredTodos,
    this.todoFilter = TodoFilter.all,
  });

  @override
  List<Object> get props => [filteredTodos, todoFilter];
}
