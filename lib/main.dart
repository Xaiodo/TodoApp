import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/blocs/todos/todo_bloc.dart';
import 'package:todo_app/database_helpers/database_helper.dart';
import 'package:todo_app/screen/home_screen.dart';
import 'package:todo_app/widgets/dependencies_provider.dart';

import 'blocs/todos_filter/todo_filter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DatabaseHelper.initDatabase();
  runApp(
    MyApp(
      database: database,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Database database;
  const MyApp({required this.database, super.key});

  @override
  Widget build(BuildContext context) {
    return DependenciedProvider(
      database: database,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                TodoBloc(repository: RepositoryProvider.of(context))
                  ..add(
                    const TodoLoaded(),
                  ),
          ),
          BlocProvider(
            create: (context) => TodoFilterBloc(
              todoBloc: context.read<TodoBloc>(),
            ),
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Space Mono',
            focusColor: const Color.fromRGBO(238, 238, 240, 1),
            primaryColor: const Color.fromRGBO(210, 154, 255, 1),
            backgroundColor: const Color.fromARGB(30, 40, 28, 50),
            scaffoldBackgroundColor: const Color.fromRGBO(30, 28, 50, 1),
            textTheme: const TextTheme(
              bodyText2: TextStyle(
                color: Color.fromRGBO(238, 238, 240, 1),
              ),
            ),
          ),
          title: 'Todo App',
          home: HomeScreen(),
        ),
      ),
    );
  }
}
