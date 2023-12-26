import 'package:web_client_api/data/providers/session_provider.dart';
import 'package:web_client_api/data/repositories/data_repository.dart';
import 'package:web_client_api/logic/models/sorting_value.dart';
import 'package:web_client_api/logic/models/session/session.dart';

class SessionRepository extends DataRepository<Session> {
  final provider = SessionProvider();

  @override
  Future<Session?> create(Session data) async {
    return await provider.create(data);
  }

  @override
  Future<String> delete(int id) async {
    return await provider.delete(id);
  }

  @override
  Future<List<Session>?> getAll({
    String? searchInput,
    SortingValue? sortingInput,
  }) async {
    List<Session>? sessionList = await provider.getAll();
    if (sessionList == null) return null;

    if (searchInput != null) {
      sessionList = sessionList
          .where((element) =>
              element.studentId.toString() == searchInput ||
              element.subjectId.toString() == searchInput)
          .toList();
    }

    if (sortingInput != null) {
      sessionList.sort((a, b) {
        switch (sortingInput) {
          case SortingValue.asc:
            return a.studentId.compareTo(b.studentId);
          case SortingValue.desc:
            return b.studentId.compareTo(a.studentId);
        }
      });
    }

    return sessionList;
  }

  @override
  Future<Session?> getById(int id) async {
    return await provider.getById(id);
  }

  @override
  Future<Session?> update(int id, Session newData) async {
    return await provider.update(id, newData);
  }
}
