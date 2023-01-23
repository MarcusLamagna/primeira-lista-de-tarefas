import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

const todoListKey = 'todo_list';

//Manipulação de dados do shared_preferences
class TodoRepository {
  late SharedPreferences sharedPreferences;

  //Obter a lista e tarefas
  Future<List<Todo>> getTodoList() async {
  sharedPreferences = await SharedPreferences.getInstance();
  final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
  //Decodificando json
   final List jsonDecoded = json.decode(jsonString) as List;
   return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  //Add metodo
  void saveTodoList(List<Todo> todos) {
    //Converter lista para objeto json
    final String jsonString = json.encode(todos);
    //Armazenando o texto/lista de tarefas
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
