import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/blocs/todos/todo_bloc.dart';
import 'package:todo_app/blocs/todos_filter/todo_filter_bloc.dart';
import 'package:todo_app/database_helpers/todo_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/model/todo_filter_model.dart';
import 'package:todo_app/model/todo_model.dart';

class _MockRepository extends Mock implements TodoRepository {
  @override
  Future<void> updateTodo({required Todo todo}) async {
    super.noSuchMethod(
      Invocation.getter(#name),
    );
  }
}

class _TestValues {
  static final todos = [
    Todo(id: '1', task: 'Test task 1', description: 'description for 1'),
    Todo(id: '2', task: 'Test task 2', description: 'description for 2'),
    // Todo(id: '3', task: 'Test task 3', description: 'description for 3'),
    // Todo(id: '4', task: 'Test task 4', description: 'description for 4'),
    // Todo(id: '5', task: 'Test task 5', description: 'description for 5'),
  ];

  static final todoTest = Todo(
    id: '6',
    task: 'Test task 6',
    description: 'description for 6',
  );
}

void main() {
  group('TodoBloc', () {
    late _MockRepository repository;

    setUp(() async {
      EquatableConfig.stringify =
          true; // for show Bloc’s states and its parameters pretty.
      repository = _MockRepository();
    });

    blocTest(
      'emits [TodoLoading, TodoLoadSuccess] states when TodosLoaded is added',
      setUp: () {
        when(() => repository.getTodos()).thenAnswer(
          (_) => Future.value(
            _TestValues.todos,
          ),
        );
      },
      build: () => TodoBloc(repository: repository),
      act: (bloc) => bloc.add(const TodoLoaded()),
      expect: () => [
        const TodoLoading(todos: []),
        TodoLoadSuccess(todos: _TestValues.todos),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded, TodoLoadFailure] states when TodoLoaded is added',
      setUp: () {
        when(
          () => repository.getTodos(),
        ).thenThrow(const TodoLoadFailure(todos: []));
      },
      seed: () => const TodoLoadSuccess(todos: []),
      build: () {
        return TodoBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const TodoLoaded()),
      expect: () => const [
        TodoLoading(todos: []),
        TodoLoadFailure(todos: []),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoadSuccess] states when TodoAdded is added',
      setUp: () {
        when(() => repository.addTodo(todo: _TestValues.todoTest)).thenAnswer(
          (_) => Future.value(),
        );
      },
      seed: () => TodoLoadSuccess(todos: _TestValues.todos),
      build: () => TodoBloc(repository: repository),
      act: (bloc) => bloc.add(TodoAdded(todo: _TestValues.todoTest)),
      expect: () => [
        TodoLoading(todos: _TestValues.todos),
        TodoLoadSuccess(todos: [..._TestValues.todos, _TestValues.todoTest]),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [Todoloading, TodoUpdate, TodoLoadSuccess] states when TodoUpdated is added',
      seed: () => TodoLoadSuccess(todos: _TestValues.todos),
      build: () => TodoBloc(repository: repository),
      act: (bloc) => bloc.add((TodoUpdated(todo: _TestValues.todos.first))),
      expect: () => [
        TodoLoading(todos: _TestValues.todos),
        TodoUpdate(todos: _TestValues.todos),
        TodoLoadSuccess(todos: _TestValues.todos)
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoDelete, TodoLoadSuccess] states when TodoDeleted is added.',
      setUp: () {
        when(() => repository.deleteTodo(
              id: _TestValues.todos.last.id,
            )).thenAnswer(
          (_) => Future.value(),
        );
      },
      seed: () => TodoLoadSuccess(todos: _TestValues.todos),
      build: () => TodoBloc(repository: repository),
      act: (bloc) => bloc.add(TodoDeleted(todo: _TestValues.todos.last)),
      expect: () => [
        TodoLoading(todos: _TestValues.todos),
        TodoDelete(todos: _TestValues.todos),
        TodoLoadSuccess(todos: [
          Todo(id: '1', task: 'Test task 1', description: 'description for 1'),
        ]),
      ],
    );
  });

  group('TodoFilterBloc', () {
    late _MockRepository repository;
    late TodoBloc todoBloc;

    setUp(() async {
      EquatableConfig.stringify =
          true; // for show Bloc’s states and its parameters pretty.
      repository = _MockRepository();
      todoBloc = TodoBloc(repository: repository);
    });

    blocTest<TodoFilterBloc, TodoFilterState>(
      'emits [TodoFilterLoading, TodoFilterLoaded] states when TodosUpdated is added.',
      build: () {
        todoBloc.add(const TodoLoaded());
        when(() => repository.getTodos()).thenAnswer(
          (invocation) => Future.value(
            _TestValues.todos,
          ),
        );
        return TodoFilterBloc(todoBloc: todoBloc);
      },
      act: (bloc) =>
          bloc.add(const TodosUpadeted(todoFilter: TodoFilter.pending)),
      expect: () => <TodoFilterState>[
        TodoFilterLoaded(
          filteredTodos: _TestValues.todos,
          todoFilter: TodoFilter.pending,
        ),
      ],
    );

    blocTest<TodoFilterBloc, TodoFilterState>(
      'emits [TodoFilterLoading, TodoFilterLoaded] states when TodoFilterUpdated is added.',
      build: () {
        todoBloc.add(const TodoLoaded());
        when(() => repository.getTodos()).thenAnswer(
          (invocation) => Future.value(
            _TestValues.todos,
          ),
        );
        return TodoFilterBloc(todoBloc: todoBloc);
      },
      act: (bloc) => bloc.add(const TodoFilterUpdated()),
      expect: () => <TodoFilterState>[
        TodoFilterLoaded(
          filteredTodos: _TestValues.todos,
          todoFilter: TodoFilter.pending,
        )
      ],
    );
  });
}
