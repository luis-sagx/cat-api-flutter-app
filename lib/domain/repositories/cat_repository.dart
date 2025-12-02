import '../entities/cat.dart';

abstract class CatRepository {
  Future<List<Cat>> getCats(int page, int limit);
  Future<List<Cat>> searchCats(String query);
}
