import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  String id;
  String task;
  String description;
  bool? isCompleted;
  bool? isDeleted;

  Todo({
    required this.id,
    required this.task,
    required this.description,
    this.isCompleted,
    this.isDeleted,
  }) {
    isCompleted = isCompleted ?? false;
    isDeleted = isDeleted ?? false;
  }

  Todo copyWith({
    String? id,
    String? task,
    String? description,
    bool? isCompleted,
    bool? isDeleted,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'description': description,
      'isCompleted': isCompleted! ? 1 : 0,
      'isDeleted': isDeleted! ? 1 : 0,
    };
  }

  Todo fromMap(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      isDeleted: json['isDeleted'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        task,
        description,
        isCompleted,
        isDeleted,
      ];
}
