import 'package:web_client_api/data/providers/subject_provider.dart';
import 'package:web_client_api/data/repositories/data_repository.dart';
import 'package:web_client_api/logic/models/sorting_value.dart';
import 'package:web_client_api/logic/models/subject/subject.dart';

class SubjectRepository extends DataRepository<Subject> {
  final provider = SubjectProvider();

  @override
  Future<Subject?> create(Subject data) async {
    return await provider.create(data);
  }

  @override
  Future<String> delete(int id) async {
    return await provider.delete(id);
  }

  @override
  Future<List<Subject>?> getAll({
    String? searchInput,
    SortingValue? sortingInput,
  }) async {
    List<Subject>? subjectList = await provider.getAll();
    if (subjectList == null) return null;

    if (searchInput != null) {
      subjectList = subjectList
          .where((element) => element.name.contains(searchInput))
          .toList();
    }

    if (sortingInput != null) {
      subjectList.sort((a, b) {
        switch (sortingInput) {
          case SortingValue.asc:
            return a.name.compareTo(b.name);
          case SortingValue.desc:
            return b.name.compareTo(a.name);
        }
      });
    }

    return subjectList;
  }

  @override
  Future<Subject?> getById(int id) async {
    return await provider.getById(id);
  }

  @override
  Future<Subject?> update(int id, Subject newData) async {
    return await provider.update(id, newData);
  }
}
