import 'package:web_client_api/data/providers/data_provider.dart';
import 'package:web_client_api/logic/models/session/session.dart';

import '../constants/string_constants.dart';

class SessionProvider extends DataProvider<Session> {
  final String link = "${hostname}sessions";

  @override
  Future<Session?> create(Session data) {
    throw UnimplementedError();
  }

  @override
  Future<String> delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Session>?> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<Session?> getById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Session?> update(int id, Session newData) {
    throw UnimplementedError();
  }
}
