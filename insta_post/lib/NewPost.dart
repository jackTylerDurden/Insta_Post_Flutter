import 'package:image_picker/image_picker.dart';

import 'HttpOverride.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'API.dart';
import 'PostViewOption.dart';
import "PostView.dart";

class NewPost extends StatefulWidget {
  final String email;
  final String password;
  NewPost({Key key, @required this.email, @required this.password})
      : super(key: key);

  @override
  _State createState() => _State(email, password);
}

class _State extends State<NewPost> {
  _State(this.email, this.password);
  File _imageFile;
  dynamic _pickImageError;
  var picker = ImagePicker();
  String imageSrc = "";
  TextEditingController _postController = TextEditingController();
  TextEditingController _hashtagController = TextEditingController();
  String email;
  String password;
  final errorMessage = 'Please enter some value';
  final _formKey = GlobalKey<FormState>();
  void showAlert(message) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  @override
  void dispose() {
    _postController.dispose();
    return super.dispose();
  }

  addPost() {
    final postText = _postController.text.trim();
    var hashTagText = _hashtagController.text.trim();
    var hashTags = hashTagText.split("#");
    hashTags.removeAt(0);
    for (int i = 0; i < hashTags.length; i++) {
      hashTags[i] = "#" + hashTags[i];
    }
    print('hashTags-------------------------->>' + hashTags.toString());
    var postBody = {};
    postBody["email"] = this.email;
    postBody["password"] = this.password;
    postBody["text"] = postText;
    postBody["hashtags"] = hashTags;
    API.createNewPost(postBody).then((response) {
      print('response.body-------------------------->>' + response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        if (resultMap["result"] == "success") {
          // showAlert("post added successfully");
          List postIdList = [];
          postIdList.add(resultMap["id"]);
          if (_imageFile != null) {
            _imageFile.readAsBytes().then((value) {
              imageSrc = base64Encode(value);
              var image = {};
              image["email"] = this.email;
              image["password"] = this.password;
              image["image"] = imageSrc;
              image["post-id"] = resultMap["id"];
              API.uploadImage(image).then((response) {
                if (response.statusCode == 200) {
                  Map<String, dynamic> resultMap = json.decode(response.body);
                  if (resultMap["result"] == "success") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostView(
                              postIdList: postIdList,
                              parentString: "",
                              email: this.email,
                              password: this.password,
                              parentType: 'View Your Post'),
                        ));
                  }
                }
              });
            });
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostView(
                      postIdList: postIdList,
                      parentString: "",
                      email: this.email,
                      password: this.password,
                      parentType: 'View Your Post'),
                ));
          }
        }
      }
    });
  }

  getImage() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker
        // ignore: deprecated_member_use
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      print('image.path---------->>>' + image.path);
      _imageFile = File(image.path);
    });
  }

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
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'New Post',
                    style: TextStyle(fontSize: 20),
                  )),
              Center(
                child: _imageFile == null
                    ? Text('No image selected.')
                    : Image.file(_imageFile),
              ),
              Card(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 8,
                  maxLength: 144,
                  controller: _postController,
                  decoration: InputDecoration.collapsed(
                      hintText: "What's on your mind ?"),
                ),
              )),
              Card(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 3,
                  maxLength: 144,
                  controller: _hashtagController,
                  decoration: InputDecoration.collapsed(
                      hintText: "Add your hashtags here"),
                ),
              )),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text('Share'),
                    onPressed: () {
                      addPost();
                    },
                  ))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: getImage,
        tooltip: 'Pick Video from gallery',
        child: const Icon(Icons.photo_library),
      ),
    );
  }
}