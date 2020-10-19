import 'package:insta_post/UserRegistration.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'API.dart';
import 'PostViewOption.dart';

class Login extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String email;
  String password;
  final errorMessage = 'Please enter some value';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    return super.dispose();
  }

  Future authenticateUser() {
    this.email = _emailController.text.trim();
    this.password = _passwordController.text.trim();
    API.authenticateUser(email, password).then((response) {
      var message = "";
      if (response.statusCode == 200) {
        Map<String, dynamic> resultMap = json.decode(response.body);
        if (resultMap['result'] == true) {
          message = "Login Successful!";
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostViewOption(
                    email: this.email,
                    password: this.password,
                  ),
                ));
          });
        } else {
          message = "Login Successful. Incorrect email or password";
          Future.delayed(Duration(seconds: 2), () {
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
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                new Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _emailController,
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
                      child: Text('Login'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          authenticateUser();
                        }
                      },
                    )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Don\'t have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signup screen
                        // Navigator.pushNamed(context, '/userReg');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserRegistration(),
                            ));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }
}
