import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '2800220278023a27bb9614e0efada5fb'; // Replace this with your key
  static const String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse("$baseUrl?q=$city&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
