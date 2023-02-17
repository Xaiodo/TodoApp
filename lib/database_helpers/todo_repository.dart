import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoRepository {
  final Database _database;

  TodoRepository(Database database) : _database = database;

  Future<List<Todo>> getTodos() async {
    final List<Map<String, dynamic>> maps = await _database.query('todos');

    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        task: maps[i]['task'],
        description: maps[i]['description'],
        isCompleted: maps[i]['isCompleted'] == 1,
        isDeleted: maps[i]['isDeleted'] == 1,
      );
    });
  }

  Future<void> addTodo({
    required Todo todo,
  }) async {
    await _database.insert('todos', todo.toMap());
  }

  Future<void> deleteTodo({
    required String id,
  }) async {
    await _database.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTodo({
    required Todo todo,
  }) async {
    await _database.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
}
