import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/database_helpers/todo_repository.dart';

class DependenciedProvider extends StatelessWidget {
  final Widget child;
  final Database database;

  const DependenciedProvider({
    required this.database,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => database,
        ),
        RepositoryProvider(
          create: (context) => TodoRepository(
            RepositoryProvider.of(context),
          ),
        )
      ],
      child: child,
    );
  }
}
