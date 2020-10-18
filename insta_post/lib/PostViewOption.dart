import 'package:flutter/material.dart';
import 'package:insta_post/Nicknames.dart';
import 'API.dart';
import 'HashTags.dart';
import 'Nicknames.dart';

class PostViewOption extends StatefulWidget {
  final String email;
  final String password;
  PostViewOption({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  _State createState() => new _State(email, password);
}

class _State extends State<PostViewOption> {
  String email;
  String password;
  _State(this.email, this.password);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'InstaPost',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('View posts by nickname'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Nicknames(
                                email: this.email,
                                password: this.password,
                              ),
                            ));
                      },
                    )),
                Container(
                    height: 75,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('View posts by hashtags'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HashTags(
                                email: this.email,
                                password: this.password,
                              ),
                            ));
                      },
                    ))
              ],
            )));
  }
}
