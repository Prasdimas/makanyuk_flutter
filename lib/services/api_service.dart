import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<Recipe>> fetchRecipes({int limit = 30, int skip = 0}) async {
    final url = Uri.parse('$baseUrl/recipes?limit=$limit&skip=$skip');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final List recipesJson = data['recipes'];
      return recipesJson.map((j) => Recipe.fromJson(j)).toList();
    } else {
      throw Exception('Failed fetch recipes: ${resp.statusCode}');
    }
  }

  Future<Recipe> fetchRecipeDetail(int id) async {
    final url = Uri.parse('$baseUrl/recipes/$id');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return Recipe.fromJson(data);
    } else {
      throw Exception('Failed fetch recipe detail: ${resp.statusCode}');
    }
  }

  Future<List<String>> fetchRecipeTags() async {
    final url = Uri.parse('$baseUrl/recipes/tags');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to fetch tags: ${resp.statusCode}');
    }
  }

  Future<List<Recipe>> fetchRecipesByTag(String tag) async {
    final url = Uri.parse('$baseUrl/recipes/tag/$tag');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final List recipesJson = data['recipes'];
      return recipesJson.map((j) => Recipe.fromJson(j)).toList();
    } else {
      throw Exception('Failed fetch by tag: ${resp.statusCode}');
    }
  }
}
