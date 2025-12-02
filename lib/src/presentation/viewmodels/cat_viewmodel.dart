import 'package:flutter/material.dart';
import '../../domain/entities/cat.dart';
import '../../domain/usescases/get_cat_usecases.dart';

class CatViewModel extends ChangeNotifier {
  final GetCatsUseCase getCatsUseCase;
  final SearchCatsUseCase searchCatsUseCase;

  CatViewModel(this.getCatsUseCase, this.searchCatsUseCase);

  List<Cat> cats = [];
  bool loading = false;
  String? errorMessage;
  int page = 0;
  final int limit = 10;
  bool hasMore = true;

  Future<void> loadCats({int? targetPage, bool refresh = false}) async {
    if (loading) return;

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (refresh) {
        page = 0;
        hasMore = true;
        cats = [];
      }
      final pageToLoad = refresh ? 0 : (targetPage ?? page);
      final newCats = await getCatsUseCase.execute(pageToLoad, limit);

      if (newCats.isEmpty && pageToLoad > 0) {
        hasMore = false;
      } else {
        cats = newCats;
        page = pageToLoad;
        hasMore = newCats.length == limit;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  void nextPage() {
    if (hasMore) {
      loadCats(targetPage: page + 1);
    }
  }

  void previousPage() {
    if (page > 0) {
      loadCats(targetPage: page - 1);
    }
  }

  Future<void> searchCats(String query) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        await loadCats(refresh: true);
      } else {
        cats = await searchCatsUseCase.execute(query);
        hasMore = false;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
