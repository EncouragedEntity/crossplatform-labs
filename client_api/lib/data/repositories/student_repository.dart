import 'package:web_client_api/data/providers/student_provider.dart';
import 'package:web_client_api/data/repositories/data_repository.dart';
import 'package:web_client_api/logic/models/sorting_value.dart';
import 'package:web_client_api/logic/models/student/student.dart';

class StudentRepository extends DataRepository<Student> {
  final provider = StudentProvider();

  @override
  Future<Student?> create(Student data) async {
    return await provider.create(data);
  }

  @override
  Future<String> delete(int id) async {
    return await provider.delete(id);
  }

  @override
  Future<List<Student>?> getAll({
    String? searchInput,
    SortingValue? sortingInput,
  }) async {
    List<Student>? studentList = await provider.getAll();
    if (studentList == null) return null;

    if (searchInput != null) {
      studentList = studentList
          .where((element) =>
              element.firstName.contains(searchInput) ||
              element.lastName.contains(searchInput))
          .toList();
    }

    if (sortingInput != null) {
      studentList.sort((a, b) {
        switch (sortingInput) {
          case SortingValue.asc:
            return a.firstName.compareTo(b.firstName);
          case SortingValue.desc:
            return b.firstName.compareTo(a.firstName);
        }
      });
    }

    return studentList;
  }

  @override
  Future<Student?> getById(int id) async {
    return await provider.getById(id);
  }

  @override
  Future<Student?> update(int id, Student newData) async {
    return await provider.update(id, newData);
  }
}
