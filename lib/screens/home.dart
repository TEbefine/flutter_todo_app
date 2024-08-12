import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/colors.dart';
import 'package:flutter_todo_app/model/todo.dart';
import 'package:flutter_todo_app/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = Todo.todoList();
  List<Todo> _foundTodo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundTodo = todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: const Text(
                          'AllTodo',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (Todo todo in _foundTodo.reversed)
                        TodoItem(
                          todos: todo,
                          onTodoChanged: _handleTodoChange,
                          onDeleteItem: _deleteTodoItem,
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: tdGrey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                          hintText: 'Add a new todo item',
                          border: InputBorder.none),
                      onSubmitted: (String value) {
                        _addTodoItem(value);
                      },
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        _addTodoItem(_todoController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: tdBlue,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }

  void _addTodoItem(String todo) {
    if (_todoController.text.trim().isEmpty) {
      print("You task can't be null");
      return;
    }

    setState(() {
      todoList.add(Todo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          todoText: todo));
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Todo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todoList;
    } else {
      results = todoList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundTodo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.network(
                'https://yt3.googleusercontent.com/ytc/AIdro_m7MWMBm4PynPndRMCxUEfNcU9Eufkk5ZkYI5RNjPchQ_c=s900-c-k-c0x00ffffff-no-rj',
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
