import 'HttpOverride.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'API.dart';

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
    print('firstName------->>' + firstName);
    print('lastName------->>' + lastName);
    print('nickName------->>' + nickName);
    print('email------->>' + email);
    print('password------->>' + password);
    var user = {};
    user['firstname'] = firstName;
    user['lastname'] = lastName;
    user['nickname'] = nickName;
    user['email'] = email;
    user['password'] = password;
    API.createNewUser(user);
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
