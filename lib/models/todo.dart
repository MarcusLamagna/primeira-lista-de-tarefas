//Título, data e horário da tarefa
class Todo {
  //Criando parametros
  Todo({required this.title, required this.dateTime});

  //Construtor
  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['datetime']);

  String title;
  DateTime dateTime;

  //Criando formato Map com Jason
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String(),
    };
  }
}
