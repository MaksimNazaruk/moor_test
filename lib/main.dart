import 'dart:async';

import 'package:flutter/material.dart';
import 'moor_tables.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moor DB Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Moor DB Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyDatabase _database;
  List<Todo> _items = [];

  @override
  void initState() {
    _database = MyDatabase();
    Timer.periodic(Duration(seconds: 3), (_) {
      _addItem();
    });
    Timer.periodic(Duration(seconds: 5), (_) {
      if (_items.length > 0) {
        _removeItem(0);
      }
    });
    super.initState();
  }

  void _addItem() {
    _database.addRandomTodo();
  }

  void _removeItem(int index) {
    _database.removeTodo(_items[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: _database.allTodosStream,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              _items = snapshot.data;
              return ListView.builder(
                itemCount: _items.length,
                itemBuilder: (ctx, index) => SizedBox(
                  height: 84,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Row(children: [
                      Expanded(
                          child: Text(
                              '${_items[index].title} ${_items[index].id.toString()}')),
                      FlatButton(
                        color: Colors.blue,
                        child: Text('Delete'),
                        onPressed: () {
                          _removeItem(index);
                        },
                      )
                    ]),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
