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

  CatViewModel({required this.getCatsUseCase, required this.searchCatsUseCase});

  Future<void> loadCats({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _page = 0;
      _cats = [];
      _hasMore = true;
    }
    if (!_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newCats = await getCatsUseCase.execute(_page, _limit);
      if (newCats.isEmpty) {
        _hasMore = false;
      } else {
        _cats.addAll(newCats);
        _page++;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
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
