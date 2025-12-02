import 'package:flutter/material.dart';
import '../../domain/entities/cat.dart';
import '../../domain/usescases/get_cat_usecases.dart';

class CatViewModel extends ChangeNotifier {
  final GetCatsUseCase getCatsUseCase;
  final SearchCatsUseCase searchCatsUseCase;

  List<Cat> _cats = [];
  bool _isLoading = false;
  String? _error;
  int _page = 0;
  final int _limit = 10;
  bool _hasMore = true;

  List<Cat> get cats => _cats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  int get page => _page;

  CatViewModel({required this.getCatsUseCase, required this.searchCatsUseCase});

  Future<void> loadCats({int? targetPage, bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (refresh) {
        _page = 0;
        _hasMore = true;
        _cats = [];
      }
      final pageToLoad = refresh ? 0 : (targetPage ?? _page);
      final newCats = await getCatsUseCase.execute(pageToLoad, _limit);

      if (newCats.isEmpty && pageToLoad > 0) {
        _hasMore = false;
      } else {
        _cats = newCats;
        _page = pageToLoad;
        _hasMore = newCats.length == _limit;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void nextPage() {
    if (_hasMore) {
      loadCats(targetPage: _page + 1);
    }
  }

  void previousPage() {
    if (_page > 0) {
      loadCats(targetPage: _page - 1);
    }
  }

  Future<void> searchCats(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        await loadCats(refresh: true);
      } else {
        _cats = await searchCatsUseCase.execute(query);
        _hasMore = false;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
