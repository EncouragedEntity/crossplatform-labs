abstract class DataProvider<T> {
  Future<List<T>?> getAll();
  Future<T?> getById(int id);
  Future<T?> create(T data);
  Future<T?> update(int id, T newData);
  Future<String> delete(int id);
}
