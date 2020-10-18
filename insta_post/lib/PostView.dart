import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'HttpOverride.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'API.dart';
import 'PostModel.dart';

class PostView extends StatefulWidget {
  final List postIdList;
  final String parentString;
  final String parentType;
  final String email;
  final String password;
  PostView(
      {Key key,
      @required this.postIdList,
      @required this.parentString,
      @required this.parentType,
      @required this.email,
      @required this.password})
      : super(key: key);

  @override
  _State createState() =>
      new _State(postIdList, parentString, parentType, email, password);
}

class _State extends State<PostView> {
  List postIdList;
  String parentString;
  String parentType;
  String email;
  String password;
  Map<String, PostModel> postsMap = new Map();
  PostModel currentPost = new PostModel();
  int currentPostIndex;
  String postText = "";
  List comments = [];
  Image postImage = Image.asset("assets/loading.gif");
  _State(this.postIdList, this.parentString, this.parentType, this.email,
      this.password);
  TextEditingController _commentController = TextEditingController();
  final errorMessage = 'Please enter some value';
  final _formKey = GlobalKey<FormState>();
  void showAlert(message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  @override
  void dispose() {
    _commentController.dispose();
    return super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('postId[0]----------->>>' + this.postIdList[0].toString());
    print('parentString----------->>>' + this.parentString.toString());
    print('parentType----------->>>' + this.parentType.toString());
    fetchPost(this.postIdList[0]);
    setState(() {
      postImage = Image.asset("assets/loading.gif");
    });
  }

  fetchPost(postId) {
    if (this.postsMap[postId] != null) {
      setState(() {
        this.currentPost = this.postsMap[postId];
      });
    } else {
      API.getPost(postId).then((response) {
        if (response.statusCode == 200) {
          Map result = json.decode(response.body);
          PostModel post = PostModel.fromJson(result['post']);
          print('post------->>>' + post.text);
          setState(() {
            this.currentPostIndex = 0;
            this.postsMap[postId.toString()] = post;
            this.currentPost = post;
            this.postText = this.currentPost.text;
            this.comments = this.currentPost.comments;
          });
          if (this.currentPost.image != -1) {
            API.getImage(this.currentPost.image).then((response) {
              Map<String, dynamic> imageMap = json.decode(response.body);
              if (imageMap["result"] == "success") {
                setState(() {
                  postImage = Image.memory(base64Decode(imageMap["image"]));
                });
              }
            });
          }
        }
      });
    }
  }

  getNextPost() {
    if (this.currentPostIndex < this.postIdList.length - 1) {
      this.currentPostIndex++;
      fetchPost(this.postIdList[this.currentPostIndex]);
    }
  }

  getPrevPost() {
    if (this.currentPostIndex > 0) {
      this.currentPostIndex--;
      fetchPost(this.postIdList[this.currentPostIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.parentType),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      this.parentString,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      this.postIdList.length.toString() + ' posts',
                      style: TextStyle(fontSize: 15),
                    )),
                _post
              ],
            )));
  }

  addComment() {
    final commentText = _commentController.text.trim();
    var postBody = {};
    postBody['email'] = this.email;
    postBody['password'] = this.password;
    postBody['comment'] = commentText;
    postBody['post-id'] = this.currentPost.id;
    API.addComment(postBody).then((response) {
      setState(() {
        comments.insert(0, commentText);
        _commentController.text = "";
      });
    });
  }

  Widget get _post {
    return Container(
        // alignment: Alignment.topLeft,
        alignment: Alignment.topRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(this.postText,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                )),
            Divider(
              height: 20,
              color: Colors.lightBlue,
            ),
            postImage,
            Divider(
              height: 20,
              color: Colors.lightBlue,
            ),
            _comments,
          ],
        ));
  }

  Widget get _comments {
    print('comments------------->>>' + this.currentPost.comments.toString());

    List<Widget> comments = [];
    comments.add(Text(
      "Comments",
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ));
    comments.add(Card(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        maxLines: 3,
        controller: _commentController,
        decoration: InputDecoration.collapsed(hintText: "Write a comment..."),
      ),
    )));

    comments.add(Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RaisedButton(
          textColor: Colors.white,
          color: Colors.blue,
          child: Text('Comment'),
          onPressed: () {
            addComment();
          },
        )));
    comments.add(Divider(
      height: 20,
      color: Colors.lightBlue,
    ));
    for (String comment in this.comments) {
      comments.add(Text(
        comment,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 15.0),
      ));
    }
    return new Container(
      alignment: Alignment.topLeft,
      child: Column(
        children: comments,
      ),
    );
  }
}
