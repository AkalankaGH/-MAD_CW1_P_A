class Todo {
  int id;
  String title;
  String description;
  String category;
  String todoDate;
  int isFinished;

  todoMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['todoDate'] = todoDate;
    mapping['isFinished'] = isFinished;

    return mapping;
  }

  todoMap1() {
    var mapping1 = Map<String, dynamic>();
    mapping1['id'] = id;
    mapping1['title'] = title;
    mapping1['description'] = description;
    mapping1['todoDate'] = todoDate;
    return mapping1;
  }


}
