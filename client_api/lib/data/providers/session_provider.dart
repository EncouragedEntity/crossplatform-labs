import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_client_api/data/constants/string_constants.dart';
import 'package:web_client_api/data/providers/data_provider.dart';
import 'package:web_client_api/logic/models/session/session.dart';

import '../../logic/models/sorting_value.dart';

class SessionProvider extends DataProvider<Session> {
  final String link = "${hostname}sessions";
  const SessionProvider();

  @override
  Future<Session?> create(Session data) async {
    final response = await http.post(
      Uri.parse(link),
      body: jsonEncode(data.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return Session.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<String> delete(int id) async {
    final response = await http.delete(Uri.parse("$link/$id"));
    if (response.statusCode == 200) {
      return "Session deleted successfully";
    }
    if (response.statusCode == 404) {
      return "Session not found";
    }
    return "Error while deleting";
  }

  @override
  Future<List<Session>?> getAll({
    String? searchInput,
    SortingValue? sortingInput,
  }) async {
    final Map<String, String> queryParams = {};
    if (sortingInput != null) {
      queryParams['_sort'] = 'subjectId';
      queryParams['_order'] = sortingInput == SortingValue.asc ? 'asc' : 'desc';
    }

    final Uri uri = Uri.parse(link).replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Session> sessions =
          data.map((json) => Session.fromJson(json)).toList();
      return sessions;
    }
    return null;
  }

  @override
  Future<Session?> getById(int id) async {
    final response = await http.get(Uri.parse("$link/$id"));

    if (response.statusCode == 200) {
      return Session.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<Session?> update(int id, Session newData) async {
    final response = await http.put(
      Uri.parse("$link/$id"),
      body: jsonEncode(newData.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Session.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
