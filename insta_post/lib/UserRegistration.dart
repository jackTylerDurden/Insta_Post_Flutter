import 'dart:convert';

import 'package:flutter/material.dart';
import 'API.dart';
import 'PostViewOption.dart';

class UserRegistration extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<UserRegistration> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final errorMessage = 'Please enter some value';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nickNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    return super.dispose();
  }

  Future registerUser() {
    var firstName = _firstNameController.text.trim();
    var lastName = _lastNameController.text.trim();
    var nickName = _nickNameController.text.trim();
    var email = _emailController.text.trim();
    var password = _passwordController.text.trim();
    var user = {};
    user['firstname'] = firstName;
    user['lastname'] = lastName;
    user['nickname'] = nickName;
    user['email'] = email;
    user['password'] = password;
    API.createNewUser(user).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        var message = "";
        if (resultMap["result"] == "success") {
          message = "Sign up successful";
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostViewOption(
                    email: email,
                    password: password,
                  ),
                ));
          });
        } else {
          message = "Sign up failed. Error messages - " + resultMap["errors"];
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
        }

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(message),
              );
            });
      }
    });
    return null;
  }

  String validateValues(value) {
    print('value------->>>' + value.toString());
    if (value.isEmpty) {
      return errorMessage;
    }
    return null;
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
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    )),
                new Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _firstNameController,
                          key: Key('firstName'),
                          validator: validateValues,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'First Name',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _lastNameController,
                          key: Key('lastName'),
                          validator: validateValues,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Last Name',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _nickNameController,
                          key: Key('nickName'),
                          validator: validateValues,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nickname',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _emailController,
                          key: Key('email'),
                          validator: validateValues,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          key: Key('password'),
                          validator: validateValues,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Sign Up'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          registerUser();
                        }
                      },
                    ))
              ],
            )));
  }
}
