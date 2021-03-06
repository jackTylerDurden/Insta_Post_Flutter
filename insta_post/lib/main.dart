import 'dart:io';

import 'package:flutter/material.dart';
import 'HttpOverride.dart';
import 'login.dart';

void main() {
  HttpOverrides.global = new HttpOverride();
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => Login(),
      // When navigating to the "/second" route, build the SecondScreen widget.
    },
  ));
}
