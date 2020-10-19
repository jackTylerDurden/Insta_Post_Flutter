import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_encoder/url_encoder.dart';

const baseUrl = 'https://bismarck.sdsu.edu/api/';
// const HttpClient httpClient;

class API {
  static Future<http.Response> authenticateUser(email, password) async {
    var url = baseUrl +
        "instapost-query/authenticate?email=" +
        email +
        "&password=" +
        password;
    url = urlEncode(text: url);
    return await http.get(url);
  }

  static Future<http.Response> createNewUser(user) async {
    var url = baseUrl + "instapost-upload/newuser";
    var body = jsonEncode(user);
    return await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
  }

  static Future<http.Response> getHashTags(startIndex, endIndex) async {
    var url = baseUrl +
        "instapost-query/hashtags-batch?start-index=" +
        startIndex.toString() +
        "&end-index=" +
        endIndex.toString();
    url = urlEncode(text: url);
    return await http.get(url);
  }

  static Future<http.Response> getNickNames() async {
    var url = baseUrl + "instapost-query/nicknames";
    url = urlEncode(text: url);
    return await http.get(url);
  }

  static Future<http.Response> getPostIdsFromHashtag(hashtag) async {
    // hashtag = encode(hashtag);
    var url = baseUrl + "instapost-query/hashtags-post-ids?hashtag=" + hashtag;
    url = urlEncode(text: url);
    return await http.get(url);
  }

  static Future<http.Response> getPost(postId) async {
    var url = baseUrl + 'instapost-query/post?post-id=' + postId.toString();
    url = urlEncode(text: url);
    return await http.get(url);
  }

  static Future<http.Response> getImage(imageId) async {
    var url = baseUrl + 'instapost-query/image?id=' + imageId.toString();
    url = urlEncode(text: url);
    return await http.get(url);
  }

  static Future<http.Response> addComment(post) async {
    var url = baseUrl + "instapost-upload/comment";
    var body = jsonEncode(post);
    print('body------->>>' + body);
    url = urlEncode(text: url);
    print('url------->>>' + url);
    return await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
  }

  static Future<http.Response> updateRating(post) async {
    var url = baseUrl + "instapost-upload/rating";
    var body = jsonEncode(post);
    url = urlEncode(text: url);
    print('url------->>>' + url);
    return await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
  }

  static Future<http.Response> createNewPost(post) async {
    var url = baseUrl + "instapost-upload/post";
    var body = jsonEncode(post);
    url = urlEncode(text: url);
    print('url------->>>' + url);
    return await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
  }

  static Future<http.Response> uploadImage(image) async {
    var url = baseUrl + "instapost-upload/image";
    var body = jsonEncode(image);
    url = urlEncode(text: url);
    print('url------->>>' + url);
    return await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
  }
}
