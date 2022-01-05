import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  int _id;
  String _bookName;
  String _authorname;

  BookItem(this._bookName, this._authorname);

  BookItem.map(dynamic obj) {
    this._bookName = obj['book_name'];
    this._authorname = obj['author_name'];
    this._id = obj['id'];
  }

  int get id => _id;

  String get bookName => _bookName;

  String get authorname => _authorname;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['book_name'] = this._bookName;
    map['author_name'] = this._authorname;

   if (this._id != null) {
      map['id'] = this._id;
    }
    return map;
  }

  BookItem.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._bookName = map['book_name'];
    this._authorname = map['author_name'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _bookName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9),
          ),
          Padding(
            padding: const EdgeInsets.only(top : 8.0),
            child: Text(
              _authorname,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
