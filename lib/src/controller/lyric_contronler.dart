import 'dart:convert' as convert;
import 'dart:io';
import 'package:guitar_chords_web/src/models/lyric.dart';
import 'package:http/http.dart' as http;

/// CommentController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class LyricController {
  // Google App Script Web URL.
  // ignore: constant_identifier_names
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzPf-0VJUp5NVEIRq9KMHz7ZtroQxzx84jzHnLhhw/exec";

  // Success Status Message
  // ignore: constant_identifier_names
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(Lyric lyric, void Function(String) callback) async {
    try {
      await http
          .post(Uri.parse(URL), body: lyric.toJson())
          .then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(Uri.parse(url!)).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  /// Async function which loads feedback from endpoint URL and returns List.
  Future<List<Lyric>> getUpdateLyricList(int idSong) async {
    try {
      final response =
          await http.get(Uri.parse("$URL?action=read&query=$idSong"));

      final jsonResponse = convert.jsonDecode(response.body) as List;
      List<Lyric> lyrics =
          jsonResponse.map((json) => Lyric.fromJson(json)).toList();
      return lyrics;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return [];
    }
  }

  /// Async function which loads feedback from endpoint URL and returns List.
  Future<List<Lyric>> getLyric() async {
    try {
      final response = await http.get(Uri.parse("$URL?action=read"));

      final jsonResponse = convert.jsonDecode(response.body) as List;
      List<Lyric> lyrics =
          jsonResponse.map((json) => Lyric.fromJson(json)).toList();
      return lyrics;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return [];
    }
  }

  Future<int> getCheckUpdate() async {
    try {
      final response = await http.get(Uri.parse("$URL?action=check_update"));

      final jsonResponse = convert.jsonDecode(response.body) as int;

      return jsonResponse;
    } on Exception catch (e) {
      print("Exception occured: $e");
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }

  Future<String> updateViewComment(int id, int value) async {
    try {
      final response =
          await http.get(Uri.parse("$URL?action=update&id=$id&value=$value"));

      final jsonResponse = response.body.toString();

      return "Đã like.";
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return "Lỗi.";
    }
  }
}
