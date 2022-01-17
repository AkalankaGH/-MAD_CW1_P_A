import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertodolistsqfliteapp/sideP/panel.dart';
import 'package:fluttertodolistsqfliteapp/models/todo.dart';
import 'package:fluttertodolistsqfliteapp/screens/todo.dart';
import 'package:fluttertodolistsqfliteapp/services/td_S.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}


class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;

  var _todo = Todo();
  final myController = TextEditingController();

  List<Todo> _todoList = List<Todo>();
  var _categories = List<DropdownMenuItem>();
  var todo;
  var _selectedValue;

  var _todoTitleController = TextEditingController();

  var _todoDescriptionController = TextEditingController();

  var _todoDateController = TextEditingController();



  @override
  initState() {
    super.initState();
    getAllTodos();
  }
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }
  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }
  searchTodos(BuildContext context, sword) async {
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.searchTodo(sword);

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }
  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }



  _editTodo(BuildContext context, todoId) async {
    todo = await _todoService.readTodoById(todoId);
    setState(() {
      _todoTitleController.text = todo[0]['title'] ?? 'No Title';
      _todoDescriptionController.text = todo[0]['description'] ?? 'No Desc';
      _todoDateController.text = todo[0]['todoDate'] ?? 'No Date';

    });
    _editTodoDialog(context);
  }

  _editTodoDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () async {
                  _todo.id = todo[0]['id'];
                  _todo.title = _todoTitleController.text;
                  _todo.description =
                      _todoDescriptionController.text;
                  _todo.todoDate =
                      _todoDateController.text;

                  var result = await _todoService.updateTodo(_todo);
                  if (result > 0) {
                    Navigator.pop(context);

                    getAllTodos();
                    _showSuccessSnackBar(Text('Updated'));
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Todo Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _todoTitleController,
                    decoration: InputDecoration(
                        labelText: 'Title', hintText: 'Write Todo Title'),
                  ),
                  TextField(
                    controller: _todoDescriptionController,
                    decoration: InputDecoration(
                        labelText: 'Description', hintText: 'Write Todo Description'),
                  ),
                  TextField(
                    controller: _todoDateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Pick a Date',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  DropdownButtonFormField(
                    value: _selectedValue,
                    items: _categories,
                    hint: Text('Category'),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, todoId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.red,
                onPressed: () async {
                  var result =
                  await _todoService.deleteCategory(todoId);
                  if (result > 0) {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                    getAllTodos();
                    _showSuccessSnackBar(Text('Deleted'));

                  }
                },
                child: Text('Delete'),
              ),
            ],
            title: Text('Do you want to delete this?'),
          );
        });
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My To-Do List'),
      ),
      drawer: DrawerNavigaton(),
      body: Column(
        children: <Widget>[
          TextField(
            controller: myController,
            decoration: InputDecoration(
              hintText: "Enter Search Term",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed:() {
                  print(myController.text);
                  searchTodos(context, myController.text);

                },
              ),

            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _todoList.length,

                itemBuilder: (context, index) {
                  var _checked;
                  return Padding(
                    padding: EdgeInsets.only(top:8.0, left: 8.0, right: 8.0),
                    child: Card(
                      elevation: 8.0,
                      child: ListTile(

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_todoList[index].title ?? 'No Title'),
                            Text(_todoList[index].description ?? 'No Desc'),

                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _deleteFormDialog(context, _todoList[index].id);
                                })
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_todoList[index].category ?? 'No Category'),
                            Text(_todoList[index].todoDate ?? 'No Date'),
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _editTodo(context, _todoList[index].id);
                                }),

                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}