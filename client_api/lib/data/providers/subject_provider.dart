import 'package:web_client_api/data/providers/data_provider.dart';
import 'package:web_client_api/logic/models/subject/subject.dart';

import '../constants/string_constants.dart';

class SubjectProvider extends DataProvider<Subject> {
  final String link = "${hostname}subjects";

  @override
  Future<Subject?> create(Subject data) {
    throw UnimplementedError();
  }

  @override
  Future<String> delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Subject>?> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<Subject?> getById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Subject?> update(int id, Subject newData) {
    throw UnimplementedError();
  }
}
