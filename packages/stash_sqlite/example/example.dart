import 'dart:io';

import 'package:stash/stash_api.dart';
import 'package:stash_sqlite/stash_sqlite.dart';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, this.completed = false});

  /// Creates a [Task] from json map
  factory Task.fromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool);

  /// Creates a json map from a [Task]
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'title': title, 'completed': completed};

  @override
  String toString() {
    return 'Task $id: "$title" is ${completed ? "completed" : "not completed"}';
  }
}

void main() async {
  // Temporary directory
  final dirPath = Directory.systemTemp;
  // Temporary database file for a shared store
  final file = File('${dirPath.path}/stash_sqlite.db');

  // Creates a store
  final store = newSqliteFileStore(
      file: file, fromEncodable: (json) => Task.fromJson(json));
  // Creates a cache with a capacity of 10 from the previously created store
  final cache1 = store.cache(
      cacheName: 'cache1',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Key "${event.entry.key}" added to the first cache'));
  // Creates a second cache with a capacity of 10 from the previously created store
  final cache2 = store.cache(
      cacheName: 'cache2',
      maxEntries: 10,
      eventListenerMode: EventListenerMode.synchronous)
    ..on<CreatedEntryEvent>().listen(
        (event) => print('Key "${event.entry.key}" added to the second cache'));

  // Adds a task with key 'task1' to the first cache
  await cache1.put('task1',
      Task(id: 1, title: 'Run shared store example (1)', completed: true));
  // Retrieves the value from the first cache
  print(await cache1.get('task1'));

  // Adds a task with key 'task1' to the second cache
  await cache2.put('task1',
      Task(id: 2, title: 'Run shared store example (2)', completed: true));
  // Retrieves the value from the second cache
  print(await cache2.get('task1'));
}
