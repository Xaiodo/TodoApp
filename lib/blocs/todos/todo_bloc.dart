// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/database_helpers/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _repository;
  TodoBloc({required TodoRepository repository})
      : _repository = repository,
        super(const TodoLoading(todos: [])) {
    on<TodoLoaded>(_onLoadTodos);
    on<TodoAdded>(_onAddTodos);
    on<TodoUpdated>(_onUpdateTodos);
    on<TodoDeleted>(_onDeleteTodos);
  }

  void _onLoadTodos(TodoLoaded event, Emitter<TodoState> emit) async {
    try {
      emit(state.loading);

      final todos = await _repository.getTodos();

      emit(
        state.loaded(todos: todos),
      );
    } catch (e) {
      emit(state.loadFailure);
    }
  }

  void _onAddTodos(TodoAdded event, Emitter<TodoState> emit) async {
    emit(state.loading);
    await _repository.addTodo(todo: event.todo);
    emit(
      state.loaded(
        todos: List.from(state.todos)..add(event.todo),
      ),
    );
  }

  void _onDeleteTodos(TodoDeleted event, Emitter<TodoState> emit) async {
    emit(state.loading);

    await _repository.deleteTodo(id: event.todo.id);
    List<Todo> todos = state.todos.where((todo) {
      return todo.id != event.todo.id;
    }).toList();

    emit(state.deletedTodo);
    emit(state.loaded(todos: todos));
  }

  void _onUpdateTodos(TodoUpdated event, Emitter<TodoState> emit) async {
    emit(state.loading);

    await _repository.updateTodo(todo: event.todo);
    List<Todo> todos = (state.todos.map((todo) {
      return todo.id == event.todo.id ? event.todo : todo;
    })).toList();

    emit(state.updated);
    emit(state.loaded(todos: todos));
  }
}
