import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_datasource.dart';

class CatRepositoryImpl implements CatRepository {
  final CatRemoteDataSource remoteDataSource;

  CatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Cat>> getCats(int page, int limit) async {
    return await remoteDataSource.getCats(page, limit);
  }

  @override
  Future<List<Cat>> searchCats(String query) async {
    return await remoteDataSource.searchCats(query);
  }
}
