import 'package:flutter/material.dart';
import 'package:todo_app/util/DatabaseHelper.dart';
import '../model/BookItem.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final TextEditingController bookController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  var dbHelper = DatabaseHelper();
  List<BookItem> _itemsList = <BookItem>[];

  @override
  void initState() {
    super.initState();
    _readTodoItemsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, int position) {
                return Card(
                  color: Colors.purple,
                  child: ListTile(
                    title: _itemsList[position],
                    onTap: () => _updateTodoItemDialog(_itemsList[position], position),
                    trailing: Listener(
                      key: Key(_itemsList[position].bookName),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPointerDown: (pointerEvent) => _deleteTodoItem(_itemsList[position].id, position)
                      ,
                    ),
                  ),
                );
              },
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemsList.length,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white10,
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
        tooltip: 'Tap to add item',
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      title: Text(
          'Add Book'
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[
          Container(
              child: TextField(
                controller: bookController,
                decoration: InputDecoration(
                   labelText: 'Book Name',
                 //   hintText: 'Book Name',
                    icon: Icon(Icons.book)),
              )),
          Container(
              child: TextField(
                controller: authorController,
                decoration: InputDecoration(
                     labelText: 'Author',
                  //  hintText: 'Author',
                    icon: Icon(Icons.account_circle)),
              ))
        ],


      ),
      actions: <Widget>[
        TextButton(

          onPressed: () {
            bookController.clear();
            authorController.clear();
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
            onPressed: () {
              _handleSubmit(bookController.text,authorController.text);
              bookController.clear();
              authorController.clear();
              Navigator.pop(context);
            },
            child: Text('Add'))

      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _handleSubmit(String book, String author) async {
    bookController.clear();
    authorController.clear();
    //var item = TodoItem(book, dateFormatted());
    var item = BookItem(book, author);
    int savedItemId = await dbHelper.saveItem(item);
    var addedItem = await dbHelper.getItem(savedItemId);
    setState(() {
      _itemsList.insert(0, addedItem);
    });
  }

  _readTodoItemsList() async {
    var items = await dbHelper.getAllItems();
    print('List $_itemsList');
    items.forEach((item) {
      setState(() {
        var todoItem = BookItem.fromMap(item);
        _itemsList.add(todoItem);
      });
    });
  }

  _deleteTodoItem(int id, int position) async{
    await dbHelper.deleteItem(id);

    setState(() {
      _itemsList.removeAt(position);
    });

  }

  _updateTodoItemDialog(BookItem item, int position) {
    var alert = AlertDialog(
      title: Text(
          'Update Item'
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[
          Container(
            child: TextField(
              controller: bookController..text=item.bookName,
              decoration: InputDecoration(
                  labelText: 'Book Name',
                  icon: Icon(Icons.book),
              ),
            ),
          ),
          Container(
            child: TextField(
              controller: authorController..text=item.authorname,
              decoration: InputDecoration(
                  labelText: 'Author',
                  icon: Icon(Icons.account_circle)
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(onPressed: () {
          Navigator.pop(context);
          bookController.clear();
          authorController.clear();
        }, child: Text(

            'Cancel'
        )),

        TextButton(onPressed: () async{
          BookItem updatedItem = BookItem.fromMap({
            'book_name' : bookController.text,
            'author_name' : authorController.text,
            'id' : item.id
          });

          _handleSubmittedUpdate(position, item);
          await dbHelper.updateItem(updatedItem);
          setState(() {
            _readTodoItemsList();
          });
          Navigator.pop(context);
          bookController.clear();
          authorController.clear();

        }, child: Text(
            'Update'
        ))
      ],

    );
    showDialog(context: context, builder: (_) {
      return alert;
    });

  }

  void _handleSubmittedUpdate(int position, BookItem item) {
    _itemsList.removeWhere((element) => _itemsList[position].id == item.id);
  }
}
