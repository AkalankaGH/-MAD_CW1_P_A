import 'package:fluttertodolistsqfliteapp/models/todo.dart';
import 'package:fluttertodolistsqfliteapp/repositories/dbcommands.dart';

class TodoService {
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }
  // Delete data from table
  deleteCategory(todoId) async{
    return await _repository.deleteData('todos', todoId);
  }
  // create todos
  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  // read todos
  readTodos() async {
    return await _repository.readData('todos');
  }

  // read todos by category
  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
  }

  // Read data from table by Id
  readTodoById(todoId) async {
    return await _repository.readDataById('todos', todoId);
  }

  // Read data from table by Id
  searchTodo(sword) async {
    return await _repository.searchTodo('todos', sword);

  }

  updateTodo(Todo todo) async {
    return await _repository.updateData('todos', todo.todoMap1());
  }

}
