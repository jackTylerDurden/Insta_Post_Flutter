import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';

import 'package:flutter_tags/flutter_tags.dart';
import 'API.dart';
import 'PostView.dart';

class HashTags extends StatefulWidget {
  // HashTags({Key key, this.title}) : super(key: key);
  // final String title;
  final String email;
  final String password;
  HashTags({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  _State createState() => _State(email, password);
}

class _State extends State<HashTags> with SingleTickerProviderStateMixin {
  bool _symmetry = false;
  bool _removeButton = true;
  bool _singleItem = false;
  bool _startDirection = false;
  bool _horizontalScroll = false;
  bool _withSuggesttions = false;
  int _count = 0;
  int _column = 0;
  int _startIndex = 0;
  int _pageSize = 80;
  double _fontSize = 14;
  String email;
  String password;
  // String title;
  _State(this.email, this.password);

  String _itemCombine = 'withTextBefore';

  List _items = new List();

  @override
  void initState() {
    super.initState();
    API.getHashTags(_startIndex, _startIndex + _pageSize).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        List<dynamic> hashTags = resultMap['hashtags'];
        setState(() {
          _items = hashTags.toList();
        });
      }
    });
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hashtags'),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            _tags1,
            Center(
              child: IconButton(
                icon: Icon(Icons.add_circle),
                color: Colors.lightBlue,
                tooltip: "for more hashtags",
                onPressed: getMoreHashTags,
              ),
            )
          ])),
    );
  }

  getMoreHashTags() {
    print('inside this function----------');
    _startIndex += _pageSize;
    API.getHashTags(_startIndex, _startIndex + _pageSize).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        List<dynamic> hashTags = resultMap['hashtags'];
        setState(() {
          _items.addAll(hashTags.toList());
        });
      }
    });
  }

  getPostIds(hashtag) {
    API.getPostIdsFromHashtag(hashtag.title).then((response) {
      Map<String, dynamic> resultMap = json.decode(response.body);
      if (resultMap['result'] == 'success') {
        List postIdList = resultMap['ids'];
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostView(
                  postIdList: postIdList,
                  parentString: hashtag.title,
                  email: this.email,
                  password: this.password,
                  parentType: 'Hashtag'),
            ));
      }
    });
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
          color: Colors.lightBlue,
          activeColor: Colors.lightBlue,
          singleItem: true,
          splashColor: Colors.lightBlue,
          textScaleFactor:
              utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
          textStyle: TextStyle(
            fontSize: _fontSize,
          ),
          onPressed: getPostIds,
        );
      },
    );
  }
}
