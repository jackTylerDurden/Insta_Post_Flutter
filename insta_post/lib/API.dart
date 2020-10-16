import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const baseUrl = 'https://bismarck.sdsu.edu/api/';
// const HttpClient httpClient;

class API {
  static Future<http.Response> authenticateUser(email, password) async {
    print('email----->>>' + email);
    print('password----->>>' + password);
    var url = baseUrl +
        "instapost-query/authenticate?email=" +
        email +
        "&password=" +
        password;
    return await http.get(url);
  }

  static Future<http.Response> createNewUser(user) async {
    print('email----->>>' + user.toString());
    var url = baseUrl + "instapost-upload/newuser";
    var body = jsonEncode(user);
    print("body------->>>" + body.toString());
    http.Response responseTemp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user));
    print('resonse------>>>' + responseTemp.statusCode.toString());
    print('resonse------>>>' + responseTemp.body.toString());
    return null;
  }
}
