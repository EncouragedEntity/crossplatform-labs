import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../logic/models/sorting_value.dart';
import '../../logic/models/student/student.dart';
import '../constants/string_constants.dart';
import 'data_provider.dart';

class StudentProvider implements DataProvider<Student> {
  final String link = "${mobileHostname}students";

  const StudentProvider();

  @override
  Future<Student?> create(Student data) async {
    final response = await http.post(
      Uri.parse(link),
      body: jsonEncode(data.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Student.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<String> delete(int id) async {
    final response = await http.delete(Uri.parse("$link/$id"));
    if (response.statusCode == 200) {
      return "Student deleted successfully";
    }
    if (response.statusCode == 404) {
      return "Student not found";
    }
    return "Error while deleting";
  }

  @override
  Future<List<Student>?> getAll({
    String? searchInput,
    SortingValue? sortingInput,
  }) async {
    final Map<String, String> queryParams = {};

    if (sortingInput != null) {
      queryParams['_sort'] = 'firstName';
      queryParams['_order'] = sortingInput == SortingValue.asc ? 'asc' : 'desc';
    }

    if (searchInput != null && searchInput.isNotEmpty) {
      queryParams['firstName_like'] = searchInput;
    }

    final Uri uri = Uri.parse(link).replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Student> students =
          data.map((json) => Student.fromJson(json)).toList();
      return students;
    }
    return null;
  }

  @override
  Future<Student?> getById(int id) async {
    final response = await http.get(Uri.parse("$link/$id"));

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<Student?> update(int id, Student newData) async {
    final response = await http.put(
      Uri.parse("$link/$id"),
      body: jsonEncode(newData.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
