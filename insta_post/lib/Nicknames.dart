import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:flutter_tags/flutter_tags.dart';
import 'API.dart';
import 'PostView.dart';

class Nicknames extends StatefulWidget {
  final String email;
  final String password;
  Nicknames({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  _State createState() => _State(email, password);
}

class _State extends State<Nicknames> with SingleTickerProviderStateMixin {
  double _fontSize = 14;
  String email;
  String password;
  int _startIndex = 0;
  int _pageSize = 50;
  var nickNamesList = [];
  _State(this.email, this.password);

  List _items = new List();

  @override
  void initState() {
    API.getNickNames().then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        List<dynamic> nicknames = resultMap['nicknames'];
        setState(() {
          // _items = nicknames.toList();
          nickNamesList = nicknames.toList();
          _items = nickNamesList.sublist(
              this._startIndex, this._startIndex + this._pageSize);
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
          child: ListView(children: <Widget>[
            _nicknames,
            Center(
              child: IconButton(
                icon: Icon(Icons.add_circle),
                color: Colors.lightBlue,
                tooltip: "for more hashtags",
                onPressed: getMoreNicknames,
              ),
            )
          ])),
    );
    // body: Padding(
    //     padding: EdgeInsets.all(10),
    //     child: ListView(children: <Widget>[_nicknames])));
  }

  getMoreNicknames() {
    _startIndex += _pageSize;
    setState(() {
      _items.addAll(nickNamesList.sublist(
          this._startIndex, this._startIndex + this._pageSize));
    });
  }

  getPostIds(nickname) {
    final nicknameVal = nickname.title.toString().trim();
    var message = "";
    var showMessage = false;
    API.getPostIdsFromNickname(nicknameVal).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        if (resultMap['result'] == 'success') {
          message = "loading";
          showMessage = false;
          List postIdList = resultMap['ids'];
          if (postIdList.length > 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostView(
                      postIdList: postIdList,
                      parentString: nickname.title,
                      email: this.email,
                      password: this.password,
                      parentType: 'Nickname'),
                ));
          } else {
            showMessage = true;
            message = "No posts from " + nicknameVal;
          }
        } else {
          showMessage = true;
          message = resultMap['errors'];
        }
        if (showMessage == true) {
          showMessage = false;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(message),
                );
              });
        }
      }
    });
  }

  Widget get _nicknames {
    return Tags(
      key: _tagStateKey,
      symmetry: false,
      columns: 0,
      horizontalScroll: false,
      //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
      // heightHorizontalScroll: 60 * (_fontSize / 14),
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
