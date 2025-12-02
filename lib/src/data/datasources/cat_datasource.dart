import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_model.dart';

class CatRemoteDataSource {
  final String baseUrl = 'https://api.thecatapi.com/v1';
  final String apiKey =
      'live_kspyR1KiSqLuXwNZ6Iso3cwzB6WfPYfkwJIXiNLYy39MAilzrE3zcDtxYFPlRsCB';

  Future<List<CatModel>> getCats(int page, int limit) async {
    final url = Uri.parse("$baseUrl/breeds?page=$page&limit=$limit");
    final resp = await http.get(url, headers: {'x-api-key': apiKey});
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => CatModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cats');
    }
  }

  Future<List<CatModel>> searchCats(String query) async {
    final url = Uri.parse("$baseUrl/breeds/search?q=$query");
    final resp = await http.get(url, headers: {'x-api-key': apiKey});
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => CatModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search cats');
    }
  }
}
