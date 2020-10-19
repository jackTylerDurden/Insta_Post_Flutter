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
  // Map<String, PostModel> postsMap = new Map();
  var postsMap = {};
  PostModel currentPost = new PostModel();

  int currentPostIndex;
  String postText = "";
  List comments = [];
  String rating = "";
  String hashTags = "";
  Image postImage = Image.asset("assets/loading.gif");

  _State(this.postIdList, this.parentString, this.parentType, this.email,
      this.password);
  TextEditingController _commentController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final errorMessage = 'Please enter some value';
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
    _ratingController.dispose();
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
        this.postText = this.currentPost.text;
        this.postText += this.currentPost.hashtags.join("");
        this.comments = this.currentPost.comments;
        this.rating = this.currentPost.ratingsAverage.toString();
      });
    } else {
      API.getPost(postId).then((response) {
        if (response.statusCode == 200) {
          Map result = json.decode(response.body);
          PostModel post = PostModel.fromJson(result['post']);
          print('post------->>>' + post.text);
          setState(() {
            this.currentPostIndex = 0;
            this.postsMap[postId] = post;
            this.currentPost = post;
            this.postText = this.currentPost.text;
            this.comments = this.currentPost.comments;
            this.rating = this.currentPost.ratingsAverage.toString();
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
          } else {
            setState(() {
              postImage = null;
            });
          }
        }
      });
    }
  }

  getNextPost() {
    if (this.currentPostIndex < this.postIdList.length - 1) {
      resetState();
      this.currentPostIndex += 1;
      print("this.currentPostIndex--------->>>" +
          this.currentPostIndex.toString());
      print("this.postIdList[this.currentPostIndex]--------->>>" +
          this.postIdList[this.currentPostIndex].toString());
      fetchPost(this.postIdList[this.currentPostIndex]);
    }
  }

  getPrevPost() {
    print("this.currentPostIndex before--------->>>" +
        this.currentPostIndex.toString());
    if (this.currentPostIndex > 0) {
      resetState();
      this.currentPostIndex -= 1;
      print("this.currentPostIndex--------->>>" +
          this.currentPostIndex.toString());
      print("this.postIdList[this.currentPostIndex]--------->>>" +
          this.postIdList[this.currentPostIndex].toString());
      fetchPost(this.postIdList[this.currentPostIndex]);
    }
  }

  resetState() {
    setState(() {
      this.currentPost = new PostModel();
      this.postText = "";
      this.comments = [];
      this.rating = "0.0";
    });
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
            children: [_post],
          )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.lightBlue,
            icon: Icon(Icons.arrow_left, color: Colors.lightBlue),
            title: Text('Previous Post'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.lightBlue,
            icon: Icon(Icons.arrow_right, color: Colors.lightBlue),
            title: Text('Next Post'),
          ),
        ],
        // currentIndex: 0,
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
    );
  }

  _onItemTapped(index) {
    print('index---->>>' + index.toString());
    if (index == 0) {
      getPrevPost();
    } else if (index == 1) {
      getNextPost();
    }
  }

  addComment() {
    final commentText = _commentController.text.trim();
    var postBody = {};
    postBody['email'] = this.email;
    postBody['password'] = this.password;
    postBody['comment'] = commentText;
    postBody['post-id'] = this.currentPost.id;
    API.addComment(postBody).then((response) {
      print('response.body--------->>>' + response.body);
      print('response.statusCode--------->>>' + response.statusCode.toString());
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        if (resultMap["result"] == "success") {
          setState(() {
            comments.add(commentText);
            _commentController.text = "";
          });
        }
      }
    });
  }

  submitRating() {
    if (_formKey.currentState.validate()) {
      final int rating = int.parse(_ratingController.text.trim());
      var postBody = {};
      postBody['email'] = this.email;
      postBody['password'] = this.password;
      postBody['rating'] = rating;
      postBody['post-id'] = this.currentPost.id;
      API.updateRating(postBody).then((response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> resultMap = json.decode(response.body);
          if (resultMap["result"] == "success") {
            //need to make another callout to fetch the post again to get the updated average rating.
            API.getPost(this.currentPost.id).then((response) {
              if (response.statusCode == 200) {
                Map result = json.decode(response.body);
                PostModel post = PostModel.fromJson(result['post']);
                setState(() {
                  this.currentPost = post;
                  this.rating = post.ratingsAverage.toString();
                  _ratingController.text = "";
                });
              }
            });
          }
        }
      });
    }
  }

  Widget get _post {
    return Container(
        // alignment: Alignment.topLeft,
        alignment: Alignment.centerLeft,
        child: Column(
          // crossAxisAlignment: ,
          children: <Widget>[
            Divider(
              height: 20,
              color: Colors.lightBlue,
            ),
            // postImage,
            postImage == null ? Text('') : postImage,
            Divider(
              height: 20,
              color: Colors.lightBlue,
            ),
            Text(this.postText,
                textAlign: TextAlign.left,
                style: new TextStyle(
                  fontSize: 18.0,
                )),
            Divider(
              height: 20,
              color: Colors.lightBlue,
            ),
            _rating,
            Divider(
              height: 20,
              color: Colors.lightBlue,
            ),
            _comments,
          ],
        ));
  }

  Widget get _rating {
    List<Widget> ratings = [];
    ratings.add(Text(
      "Average rating : " + this.rating,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ));
    ratings.add(Card(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      // child:TextFormField(
      //   maxLines: 1,
      //   controller: _ratingController,
      //   validator: _validateRating,
      //   keyboardType: TextInputType.number,
      //   decoration: InputDecoration.collapsed(hintText: "Rate this image"),
      // ),
      child: Form(
        key: _formKey,
        child: TextFormField(
          maxLines: 1,
          controller: _ratingController,
          validator: _validateRating,
          keyboardType: TextInputType.number,
          decoration: InputDecoration.collapsed(hintText: "Rate this image"),
        ),
      ),
    )));
    ratings.add(Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RaisedButton(
          textColor: Colors.white,
          color: Colors.blue,
          child: Text('Submit your rating'),
          onPressed: () {
            submitRating();
          },
        )));
    return new Container(child: Column(children: ratings));
  }

  String _validateRating(value) {
    int ratingVal = int.parse(value);
    if (ratingVal > 5 || ratingVal < 1) {
      return "Please enter the rating from 1 to 5 (inclusive)";
    }
    return null;
  }

  Widget get _comments {
    // print('comments------------->>>' + this.currentPost.comments.toString());

    List<Widget> comments = [];
    comments.add(Text(
      "Comments",
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ));
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
    return new Container(
      alignment: Alignment.topLeft,
      child: Column(
        children: comments,
      ),
    );
  }
}
