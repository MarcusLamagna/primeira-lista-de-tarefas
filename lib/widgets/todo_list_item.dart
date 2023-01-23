import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({Key? key, required this.todo, required this.onDelete,})
      : super(key: key);

  final Todo todo;

  //Funcao Deletar
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      //Espaçamento por fora do Slidable e Container
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        //Criando botão
        endActionPane: ActionPane(
          motion: StretchMotion(),
          extentRatio: 0.50,
          children: [
            //Botão Deletar
            SlidableAction(
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
              //Funcao deletar
              onPressed: (context) {
                onDelete(todo);
              },
            ),
            //Boatão Editar
            SlidableAction(
              backgroundColor: Colors.blue,
              icon: Icons.edit,
              label: 'Editar',
              //Funcao editar
              onPressed: (context) {},
            ),
          ],
        ),
      ),
    );
  }
}
