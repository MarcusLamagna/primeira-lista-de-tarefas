import 'package:flutter/material.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  //Lista de objetos
  List<Todo> todos = [];

  //Recuperar tarefas ao deletar
  Todo? deletedTodo;

  //Armazenar/recuperar tarefa da posicao deletada
  int? deletedTodoPos;

  String? errorText;

  //Indica que iremos sobrescrever um método de uma classe mãe
  @override
  void initState() {
    super.initState();

    //Acessar repositorio
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
              child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicine uma tarefa',
                          hintText: 'Ex. Estudar Flutter',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff00d7f3),
                            width: 2,
                          )),
                          labelStyle: TextStyle(
                            color: Color(0xff00d7f3),
                          ))),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    String text = todoController.text;
                    if (text.isEmpty) {
                      setState(() {
                        errorText = 'Por favor, digite alguma tarefa!';
                      });
                      return;
                    }
                    setState(() {
                      Todo newTodo = Todo(
                        title: text,
                        dateTime: DateTime.now(),
                      );
                      todos.add(newTodo);
                      errorText = null;
                    });
                    //Limpar lista
                    todoController.clear();
                    //Salvar Lista
                    todoRepository.saveTodoList(todos);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff00d7f3),
                    padding: EdgeInsets.all(14),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (Todo todo in todos)
                    TodoListItem(
                      todo: todo,
                      onDelete: onDelete,
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    //Apresentando o tamanho da lista
                    'Você possui ${todos.length} tarefas pendentes',
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: showDeleteTodosConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff00d7f3),
                    padding: EdgeInsets.all(14),
                  ),
                  child: Text('Limpar tudo'),
                )
              ],
            )
          ],
        ),
      ))),
    );
  }

  //Funcao deletar
  void onDelete(Todo todo) {
    //Salvar/saber tarefa para recuperar na posicao que estava
    deletedTodo = todo;
    //Verificar onde está/qual indice da tarefa
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    //Remover SnackBar deletado
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!',
          style: TextStyle(color: Color(0xff060708)),
        ),
        backgroundColor: Colors.white,
        //Botao dentro de SnackBar
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
        //Duracao do SnakBar
        duration: const Duration(seconds: 5),
      ),
    );
  }

  //Funcao Limpar tudo
  void showDeleteTodosConfirmationDialog() {
    //Diálogo de confirmacao
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),

        //Botao limpar tudo e cancelar
        actions: [
          TextButton(
            onPressed: () {
              //Fechar dialogo ao clicar em cancelar
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Color(0xff00d7f3),
            ),
            child: Text('Calcelar'),
          ),
          TextButton(
            onPressed: () {
              //Fechar dialogo ao clicar em cancelar
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: Text('Limpar Tudo'),
          ),
        ],
      ),
    );
  }

  //Funcao limpar todas as tarefas de uma única vez
  void deleteAllTodos() {
    //setState - atualiza a tela após efetuar algum evento
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
