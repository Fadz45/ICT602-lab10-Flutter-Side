// food_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_10/food_model.dart';

class FoodApi {
  static const String apiUrl = "http://10.0.2.2:8000/api/foods";

  static Future<List<Food>> fetchFoods() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((food) => Food.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load foods');
    }
  }

  static Future<Map<String, dynamic>> fetchFoodById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load food');
    }
  }

  static Future<void> addFood(Map<String, String> body) async {
    final response = await http.post(Uri.parse(apiUrl), body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to add food');
    }
  }

  static Future<void> updateFood(int id, Map<String, String> body) async {
    final response = await http.put(Uri.parse('$apiUrl/$id'), body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to update food');
    }
  }

  static Future<void> deleteFood(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete food');
    }
  }
}
