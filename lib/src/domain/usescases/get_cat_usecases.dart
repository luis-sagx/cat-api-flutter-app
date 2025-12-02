import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class GetCatsUseCase {
  final CatRepository repository;

  GetCatsUseCase(this.repository);

  Future<List<Cat>> execute(int page, int limit) async {
    return await repository.getCats(page, limit);
  }
}

class SearchCatsUseCase {
  final CatRepository repository;

  SearchCatsUseCase(this.repository);

  Future<List<Cat>> execute(String query) async {
    return await repository.searchCats(query);
  }
}
