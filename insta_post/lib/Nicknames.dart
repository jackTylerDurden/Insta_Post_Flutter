import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:flutter_tags/flutter_tags.dart';
import 'API.dart';

class Nicknames extends StatefulWidget {
  final String email;
  final String password;
  Nicknames({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  _State createState() => _State(email, password);
}

class _State extends State<Nicknames> with SingleTickerProviderStateMixin {
  bool _symmetry = false;
  bool _removeButton = true;
  bool _singleItem = false;
  bool _startDirection = false;
  bool _horizontalScroll = false;
  bool _withSuggesttions = false;
  int _count = 0;
  int _column = 0;
  double _fontSize = 14;
  String email;
  String password;
  _State(this.email, this.password);

  String _itemCombine = 'withTextBefore';

  List _items = new List();

  @override
  void initState() {
    API.getNickNames().then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        List<dynamic> nicknames = resultMap['nicknames'];
        setState(() {
          _items = nicknames.toList();
        });
        print('hashTags----->>>' + _items.length.toString());
      }
    });
    super.initState();
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nicknames'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(children: <Widget>[_tags1])));
  }

  Widget get _tags1 {
    return Tags(
      key: _tagStateKey,
      symmetry: _symmetry,
      columns: _column,
      horizontalScroll: _horizontalScroll,
      //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
      heightHorizontalScroll: 60 * (_fontSize / 14),
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          pressEnabled: true,
          activeColor: Colors.blueGrey[600],
          singleItem: _singleItem,
          splashColor: Colors.green,
          combine: ItemTagsCombine.withTextBefore,
          textScaleFactor:
              utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
          textStyle: TextStyle(
            fontSize: _fontSize,
          ),
          onPressed: (item) => print(item),
        );
      },
    );
  }
}
