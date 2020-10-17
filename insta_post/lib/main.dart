import 'dart:io';

import 'package:flutter/material.dart';
import 'HttpOverride.dart';
import 'UserRegistration.dart';
import 'login.dart';
import 'HashTags.dart';
import 'Nicknames.dart';

void main() {
  HttpOverrides.global = new HttpOverride();
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    initialRoute: '/hashtags',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => Login(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/userreg': (context) => UserRegistration(),
      '/hashtags': (context) => HashTags(),
      '/nicknames': (context) => Nicknames()
    },
  ));
}
