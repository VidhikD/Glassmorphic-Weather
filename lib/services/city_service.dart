import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class CityService {
  final String _apiKey = '2800220278023a27bb9614e0efada5fb';
  final List<String> _defaultCities = [
    "London", "Delhi", "Tokyo", "Paris", "Berlin",
  ];

  Future<List<String>> getCitySuggestions(String query) async {
    if (query.isEmpty) {
      return _defaultCities..shuffle(Random());
    }

    final url = Uri.parse(
        "http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((city) => city["name"].toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
