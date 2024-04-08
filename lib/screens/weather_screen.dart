import 'package:flutter/material.dart';
import '../services/weather_api_client.dart';
import '../models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherApiClient = WeatherApiClient();
  Weather? _weather;
  String _city = 'London'; // Default city for demonstration

  @override
  void initState() {
    super.initState();
    _fetchWeather(_city);
  }

  void _fetchWeather(String city) async {
    try {
      final weather = await _weatherApiClient.fetchWeather(city);
      setState(() {
        _weather = weather;
        _city = city;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load weather. Tap to retry.')),
      );
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String city = '';
        return AlertDialog(
          title: Text('Enter a city'),
          content: TextField(
            onChanged: (value) {
              city = value;
            },
            decoration: InputDecoration(hintText: "City Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Search'),
              onPressed: () {
                Navigator.of(context).pop();
                _fetchWeather(city);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _weatherInfo(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 30, color: Colors.blue),
          SizedBox(width: 24),
          Expanded(
            child: Text(title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Text(value, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: _weather == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _weatherInfo(
                    'City',
                    _city,
                    Icons.location_city,
                  ),
                  _weatherInfo(
                    'Temperature',
                    '${_weather!.temperature.toStringAsFixed(1)}°C',
                    Icons.thermostat_outlined,
                  ),
                  _weatherInfo(
                    'Description',
                    _weather!.description,
                    Icons.description,
                  ),
                  _weatherInfo(
                    'High/Low',
                    '${_weather!.tempMax.toStringAsFixed(1)}/${_weather!.tempMin.toStringAsFixed(1)} °C',
                    Icons.wb_sunny,
                  ),
                  _weatherInfo(
                    'Wind Speed',
                    '${_weather!.windSpeed} m/s',
                    Icons.air,
                  ),
                  _weatherInfo(
                    'Humidity',
                    '${_weather!.humidity}%',
                    Icons.water_drop,
                  ),
                  _weatherInfo(
                    'Pressure',
                    '${_weather!.pressure} hPa',
                    Icons.speed,
                  ),
                ],
              ),
            ),
    );
  }
}
