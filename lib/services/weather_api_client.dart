import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApiClient {
  final baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final apiKey = 'd7a6505bd22a78ee0121216ee1396efa';

  Future<Weather> fetchWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error fetching weather data');
    }
  }
}
