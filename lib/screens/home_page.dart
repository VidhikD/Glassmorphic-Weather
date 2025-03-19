import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:ui';
import '../services/weather_service.dart';
import '../services/city_service.dart';
import '../widgets/background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  final CityService _cityService = CityService();
  String _city = "London";
  double _temperature = 0;
  String _weatherCondition = "Clear";
  int _humidity = 0;
  double _windSpeed = 0;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() async {
    try {
      var data = await _weatherService.fetchWeather(_city);
      setState(() {
        _temperature = data['main']['temp'];
        _weatherCondition = data['weather'][0]['main'];
        _humidity = data['main']['humidity'];
        _windSpeed = data['wind']['speed'];
      });
    } catch (e) {
      setState(() {
        _weatherCondition = "Error";
      });
    }
  }

  void _searchCity(String city) {
    setState(() {
      _city = city;
    });
    _loadWeather();
  }

  IconData _getWeatherIcon() {
    switch (_weatherCondition) {
      case "Clouds":
        return FontAwesomeIcons.cloud;
      case "Rain":
        return FontAwesomeIcons.cloudRain;
      case "Snow":
        return FontAwesomeIcons.snowflake;
      case "Clear":
        return FontAwesomeIcons.sun;
      default:
        return FontAwesomeIcons.cloudSun;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for contrast
      body: Stack(
        children: [
          // 🔹 Animated Background
          Positioned.fill(
            child: AnimatedBackground(
              weatherCondition: _weatherCondition,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 Fixed Search Bar (No Errors)
                  TypeAheadField<String>(
                    builder: (context, controller, focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter city name",
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor:
                              Colors.white.withOpacity(0.2), // Visible field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      );
                    },
                    suggestionsCallback: (pattern) async {
                      return await _cityService.getCitySuggestions(pattern);
                    },
                    itemBuilder: (context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion,
                            style: TextStyle(color: Colors.black)),
                      );
                    },
                    onSelected: (String suggestion) {
                      _cityController.text = suggestion;
                      _searchCity(suggestion);
                    },
                  ),

                  SizedBox(height: 20),

                  // 🔹 Weather Info Card
                  Expanded(
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _city,
                                      style: GoogleFonts.lato(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: 20),
                                    Icon(_getWeatherIcon(),
                                        size: 80, color: Colors.white),
                                    SizedBox(height: 20),
                                    Text(
                                      "${_temperature.toStringAsFixed(1)}°C",
                                      style: GoogleFonts.lato(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _infoCard("Humidity", "$_humidity%",
                                            FontAwesomeIcons.tint),
                                        SizedBox(width: 20),
                                        _infoCard("Wind", "$_windSpeed m/s",
                                            FontAwesomeIcons.wind),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(height: 5),
          Text(
            title,
            style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
