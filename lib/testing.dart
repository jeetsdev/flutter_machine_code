// import 'package:clean_todo/data/todo_entity.dart';
// import 'package:clean_todo/data/todo_remote_repository.dart';
// import 'package:clean_todo/domain/todo_dto.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   late TodoRemoteRepository repository;

//   setUp(() {
//     repository = TodoRemoteRepository();
//   });

//   group('TodoRemoteRepository', () {
//     group('fetchTodos', () {
//       test('should return empty list when no todos are added', () async {
//         // Act
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, isEmpty);
//         expect(result, isA<List<TodoDTO>>());
//       });

//       test('should return todos after adding them', () async {
//         // Arrange
//         final todo1 = TodoDTO(id: '1', title: 'First Todo', isDone: false);
//         final todo2 = TodoDTO(id: '2', title: 'Second Todo', isDone: true);

//         await repository.addTodo(todo1);
//         await repository.addTodo(todo2);

//         // Act
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(2));
//         expect(result[0].id, equals('1'));
//         expect(result[0].title, equals('First Todo'));
//         expect(result[0].isDone, equals(false));
//         expect(result[1].id, equals('2'));
//         expect(result[1].title, equals('Second Todo'));
//         expect(result[1].isDone, equals(true));
//       });

//       test('should simulate network latency', () async {
//         // Arrange
//         final stopwatch = Stopwatch()..start();

//         // Act
//         await repository.fetchTodos();

//         // Assert
//         stopwatch.stop();
//         expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(300));
//       });
//     });

//     group('addTodo', () {
//       test('should add todo to repository', () async {
//         // Arrange
//         final todo = TodoDTO(id: 'test-id', title: 'Test Todo', isDone: false);

//         // Act
//         await repository.addTodo(todo);
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(1));
//         expect(result.first.id, equals('test-id'));
//         expect(result.first.title, equals('Test Todo'));
//         expect(result.first.isDone, equals(false));
//       });

//       test('should add multiple todos in order', () async {
//         // Arrange
//         final todo1 = TodoDTO(id: '1', title: 'First', isDone: false);
//         final todo2 = TodoDTO(id: '2', title: 'Second', isDone: true);
//         final todo3 = TodoDTO(id: '3', title: 'Third', isDone: false);

//         // Act
//         await repository.addTodo(todo1);
//         await repository.addTodo(todo2);
//         await repository.addTodo(todo3);

//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(3));
//         expect(result[0].title, equals('First'));
//         expect(result[1].title, equals('Second'));
//         expect(result[2].title, equals('Third'));
//       });

//       test('should handle todos with special characters', () async {
//         // Arrange
//         final todo = TodoDTO(
//           id: 'special-id',
//           title: 'Todo with émojis 🚀 and symbols @#\$%',
//           isDone: false,
//         );

//         // Act
//         await repository.addTodo(todo);
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(1));
//         expect(result.first.title,
//             equals('Todo with émojis 🚀 and symbols @#\$%'));
//       });
//     });

//     group('toggleTodo', () {
//       test('should toggle todo status from false to true', () async {
//         // Arrange
//         final todo =
//             TodoDTO(id: 'toggle-id', title: 'Toggle Todo', isDone: false);
//         await repository.addTodo(todo);

//         // Act
//         await repository.toggleTodo('toggle-id');
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(1));
//         expect(result.first.isDone, equals(true));
//       });

//       test('should toggle todo status from true to false', () async {
//         // Arrange
//         final todo =
//             TodoDTO(id: 'toggle-id', title: 'Toggle Todo', isDone: true);
//         await repository.addTodo(todo);

//         // Act
//         await repository.toggleTodo('toggle-id');
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(1));
//         expect(result.first.isDone, equals(false));
//       });

//       test('should toggle specific todo by id', () async {
//         // Arrange
//         final todo1 = TodoDTO(id: '1', title: 'First', isDone: false);
//         final todo2 = TodoDTO(id: '2', title: 'Second', isDone: false);
//         final todo3 = TodoDTO(id: '3', title: 'Third', isDone: false);

//         await repository.addTodo(todo1);
//         await repository.addTodo(todo2);
//         await repository.addTodo(todo3);

//         // Act
//         await repository.toggleTodo('2');
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(3));
//         expect(result[0].isDone, equals(false)); // First todo unchanged
//         expect(result[1].isDone, equals(true)); // Second todo toggled
//         expect(result[2].isDone, equals(false)); // Third todo unchanged
//       });

//       test('should do nothing when toggling non-existent todo', () async {
//         // Arrange
//         final todo =
//             TodoDTO(id: 'existing-id', title: 'Existing Todo', isDone: false);
//         await repository.addTodo(todo);

//         // Act
//         await repository.toggleTodo('non-existent-id');
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(1));
//         expect(result.first.isDone, equals(false)); // Should remain unchanged
//       });

//       test('should handle multiple toggles correctly', () async {
//         // Arrange
//         final todo =
//             TodoDTO(id: 'multi-toggle', title: 'Multi Toggle', isDone: false);
//         await repository.addTodo(todo);

//         // Act & Assert
//         await repository.toggleTodo('multi-toggle');
//         var result = await repository.fetchTodos();
//         expect(result.first.isDone, equals(true));

//         await repository.toggleTodo('multi-toggle');
//         result = await repository.fetchTodos();
//         expect(result.first.isDone, equals(false));

//         await repository.toggleTodo('multi-toggle');
//         result = await repository.fetchTodos();
//         expect(result.first.isDone, equals(true));
//       });
//     });

//     group('deleteTodo', () {
//       test('should delete todo by id', () async {
//         // Arrange
//         final todo =
//             TodoDTO(id: 'delete-id', title: 'Delete Me', isDone: false);
//         await repository.addTodo(todo);

//         // Act
//         await repository.deleteTodo('delete-id');
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, isEmpty);
//       });

//       test('should delete specific todo from multiple todos', () async {
//         // Arrange
//         final todo1 = TodoDTO(id: '1', title: 'Keep Me', isDone: false);
//         final todo2 = TodoDTO(id: '2', title: 'Delete Me', isDone: false);
//         final todo3 = TodoDTO(id: '3', title: 'Keep Me Too', isDone: false);

//         await repository.addTodo(todo1);
//         await repository.addTodo(todo2);
//         await repository.addTodo(todo3);

//         // Act
//         await repository.deleteTodo('2');
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(2));
//         expect(result[0].id, equals('1'));
//         expect(result[0].title, equals('Keep Me'));
//         expect(result[1].id, equals('3'));
//         expect(result[1].title, equals('Keep Me Too'));
//       });

//       test('should do nothing when deleting non-existent todo', () async {
//         // Arrange
//         final todo =
//             TodoDTO(id: 'existing-id', title: 'Existing Todo', isDone: false);
//         await repository.addTodo(todo);

//         // Act
//         await repository.deleteTodo('non-existent-id');
//         final result = await repository.fetchTodos();

//         // Assert
//         expect(result, hasLength(1));
//         expect(result.first.id, equals('existing-id'));
//       });

//       test('should handle deleting all todos one by one', () async {
//         // Arrange
//         final todo1 = TodoDTO(id: '1', title: 'First', isDone: false);
//         final todo2 = TodoDTO(id: '2', title: 'Second', isDone: false);
//         final todo3 = TodoDTO(id: '3', title: 'Third', isDone: false);

//         await repository.addTodo(todo1);
//         await repository.addTodo(todo2);
//         await repository.addTodo(todo3);

//         // Act & Assert
//         await repository.deleteTodo('1');
//         var result = await repository.fetchTodos();
//         expect(result, hasLength(2));

//         await repository.deleteTodo('2');
//         result = await repository.fetchTodos();
//         expect(result, hasLength(1));

//         await repository.deleteTodo('3');
//         result = await repository.fetchTodos();
//         expect(result, isEmpty);
//       });
//     });

//     group('integration tests', () {
//       test('should handle complete CRUD operations', () async {
//         // Create
//         final todo1 = TodoDTO(id: '1', title: 'Learn Flutter', isDone: false);
//         final todo2 = TodoDTO(id: '2', title: 'Build App', isDone: false);

//         await repository.addTodo(todo1);
//         await repository.addTodo(todo2);

//         var result = await repository.fetchTodos();
//         expect(result, hasLength(2));

//         // Update (toggle)
//         await repository.toggleTodo('1');
//         result = await repository.fetchTodos();
//         expect(result[0].isDone, equals(true));
//         expect(result[1].isDone, equals(false));

//         // Delete
//         await repository.deleteTodo('1');
//         result = await repository.fetchTodos();
//         expect(result, hasLength(1));
//         expect(result.first.id, equals('2'));
//       });

//       test('should maintain data consistency across operations', () async {
//         // Arrange
//         final todos = List.generate(
//           10,
//           (index) => TodoDTO(
//             id: 'id-$index',
//             title: 'Todo $index',
//             isDone: index % 2 == 0,
//           ),
//         );

//         // Add all todos
//         for (final todo in todos) {
//           await repository.addTodo(todo);
//         }

//         // Act & Assert
//         var result = await repository.fetchTodos();
//         expect(result, hasLength(10));

//         // Toggle even indexed todos
//         for (int i = 0; i < 10; i += 2) {
//           await repository.toggleTodo('id-$i');
//         }

//         result = await repository.fetchTodos();
//         for (int i = 0; i < result.length; i++) {
//           if (i % 2 == 0) {
//             expect(result[i].isDone, equals(false)); // Was true, now false
//           } else {
//             expect(result[i].isDone, equals(false)); // Was false, still false
//           }
//         }

//         // Delete odd indexed todos
//         for (int i = 1; i < 10; i += 2) {
//           await repository.deleteTodo('id-$i');
//         }

//         result = await repository.fetchTodos();
//         expect(result, hasLength(5)); // Only even indexed todos remain
//       });
//     });

//     group('TodoDTOExtension', () {
//       test('should convert empty list of entities to empty list of DTOs', () {
//         // Arrange
//         final entities = <TodoEntity>[];

//         // Act
//         final result = entities.toDomain();

//         // Assert
//         expect(result, isEmpty);
//         expect(result, isA<List<TodoDTO>>());
//       });

//       test('should convert entities to DTOs correctly', () {
//         // Arrange
//         final entities = [
//           TodoEntity(id: '1', title: 'First', isDone: false),
//           TodoEntity(id: '2', title: 'Second', isDone: true),
//         ];

//         // Act
//         final result = entities.toDomain();

//         // Assert
//         expect(result, hasLength(2));
//         expect(result[0], isA<TodoDTO>());
//         expect(result[0].id, equals('1'));
//         expect(result[0].title, equals('First'));
//         expect(result[0].isDone, equals(false));
//         expect(result[1], isA<TodoDTO>());
//         expect(result[1].id, equals('2'));
//         expect(result[1].title, equals('Second'));
//         expect(result[1].isDone, equals(true));
//       });
//     });
//   });
// }




// // Future<void> addTodo(TodoDTO todo) async {
//   //   _mockDb.add({
//   //     'id': todo.id,
//   //     'title': todo.title,
//   //     'isDone': todo.isDone,
//   //   });
//   // }

//   // Future<void> toggleTodo(String id) async {
//   //   final index = _mockDb.indexWhere((e) => e['id'] == id);
//   //   if (index != -1) {
//   //     _mockDb[index]['isDone'] = !_mockDb[index]['isDone'];
//   //   }
//   // }

//   // Future<void> deleteTodo(String id) async {
//   //   _mockDb.removeWhere((e) => e['id'] == id);
//   // }