import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_client_api/data/constants/string_constants.dart';
import 'package:web_client_api/logic/models/subject/subject.dart';

import 'data_provider.dart';

class SubjectProvider extends DataProvider<Subject> {
  final String link = "${hostname}subjects";

  @override
  Future<Subject?> create(Subject data) async {
    final response = await http.post(
      Uri.parse(link),
      body: jsonEncode(data.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Subject.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<String> delete(int id) async {
    final response = await http.delete(Uri.parse("$link/$id"));
    if (response.statusCode == 200) {
      return "Subject deleted successfully";
    }
    if (response.statusCode == 404) {
      return "Subject not found";
    }
    return "Error while deleting";
  }

  @override
  Future<List<Subject>?> getAll() async {
    final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Subject> subjects =
          data.map((json) => Subject.fromJson(json)).toList();
      return subjects;
    }
    return null;
  }

  @override
  Future<Subject?> getById(int id) async {
    final response = await http.get(Uri.parse("$link/$id"));

    if (response.statusCode == 200) {
      return Subject.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<Subject?> update(int id, Subject newData) async {
    final response = await http.put(
      Uri.parse("$link/$id"),
      body: jsonEncode(newData.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Subject.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
