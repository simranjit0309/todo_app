
import 'dart:convert';

class TodoModel {
  TodoModel({
    this.todo,
    this.place,
    this.time,
    this.category,
    this.todoId,
    this.isSelected = false
  });

  final String? todo;
  final String? place;
  final String? time;
  final String? category;
  final String? todoId;
   bool isSelected = false;

  factory TodoModel.fromJson(String str) => TodoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
    todo: json["todo"],
    place: json["place"],
    time: json["time"],
    category: json["category"],
    todoId: json["todoId"],
      isSelected: json["isSelected"]
  );

  Map<String, dynamic> toMap() => {
    "todo": todo,
    "place": place,
    "time": time,
    "category": category,
    "todoId": todoId,
    "isSelected": isSelected,
  };
}
