import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app4/weather_main_page.dart';

class Weather {
  final int? max;
  final int? min;
  final int? current;
  final String? name;
  final String? day;
  final int? wind;
  final int? humidity;
  final int? chanceRain;
  final String image;
  final String? time;
  final String? location;
  final String? description;

  Weather(
      {this.max,
      this.min,
      this.name,
      this.day,
      this.wind,
      this.humidity,
      this.chanceRain,
      required this.image,
      this.current,
      this.time,
      this.location,
      this.description});
}

Position? _currentPosition;
String? _currentAddress;

String appId = "9233805c2fc2bced2f6ee9e55842ffb4";
//https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId
//https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json

Future<List?> fetchData(double lat, double lon, String city) async {
  var url =
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId";
  var response = await http.get(Uri.parse(url));
  DateTime date = DateTime.now();
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    //current Temp
    var current = data["current"];
    Weather currentTemp = Weather(
        current: current["temp"]?.round() ?? 0,
        name: current["weather"][0]["main"].toString(),
        day: DateFormat("EEEE dd MMMM").format(date),
        wind: current["wind_speed"]?.round() ?? 0,
        humidity: current["humidity"]?.round() ?? 0,
        description: current['weather'][0]['description'],
        chanceRain: current["uvi"]?.round() ?? 0,
        location: city,
        image: "http://openweathermap.org/img/w/" +
              current["weather"]["icon"] +
              ".png",);

    List<Weather> todayWeather = [];
    int hour = date.hour;
    for (var i = 0; i < 24; i++) {
      var temp = data['hourly'][i];
      var hourly = Weather(
          current: temp['temp']?.round() ?? 0,
          image: "http://openweathermap.org/img/w/" +
              temp["weather"]["icon"] +
              ".png",

          //image: findIcon(temp["weather"][0]["main"].toString(), false),
          //image: 'assets/assets/rainy.png',
          time: '${(hour + i + 1) % 24}:00',
          description: temp['weather'][0]['description']);
      todayWeather.add(hourly);
    }

    List<Weather> sevenDay = [];
    for (var i = 0; i < 8; i++) {
      String day = DateFormat('EEEE')
          .format(DateTime(date.year, date.month, date.day + i + 1))
          .substring(0, 3);
      var temp = data['daily'][i];
      var hourly = Weather(
        max: temp['temp']['max']?.round() ?? 0,
        min: temp['temp']['min']?.round() ?? 0,
        image: "http://openweathermap.org/img/w/" +
            temp["weather"]["icon"] +
            ".png",

        //image: findIcon(temp["weather"][0]["main"].toString(), false),
        //description: temp['weather'][0]['description'],
        //image: 'assets/assets/rainy.png',
        name: temp['weather'][0]['main'].toString(),
        day: day,
      );
      sevenDay.add(hourly);
    }
    return [currentTemp, todayWeather, sevenDay];
  }
  return [null, null, null];
}

String findIcon(String name, bool type) {
  if (type) {
    switch (name) {
      case "Clouds":
        return "assets/sunny.png";

      case "Rain":
        return "assets/rainy.png";

      case "Drizzle":
        return "assets/rainy.png";

      case "Thunderstorm":
        return "assets/thunder.png";

      case "Snow":
        return "assets/snow.png";

      default:
        return "assets/sunny.png";
    }
  } else {
    switch (name) {
      case "Clouds":
        return "assets/sunny_2d.png";

      case "Rain":
        return "assets/rainy_2d.png";

      case "Drizzle":
        return "assets/rainy_2d.png";

      case "Thunderstorm":
        return "assets/thunder_2d.png";

      case "Snow":
        return "assets/snow_2d.png";

      default:
        return "assets/sunny_2d.png";
    }
  }
}

class CityModel {
  final String? name;
  final String? lat;
  final String? lon;
  CityModel({this.name, this.lat, this.lon});
}

var cityJSON;

Future<CityModel?> fetchCity(String cityName) async {
  if (cityJSON == null) {
    String link =
        "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
    var response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      cityJSON = json.decode(response.body);
    }
  }
  for (var i = 0; i < cityJSON.length; i++) {
    if (cityJSON[i]["name"].toString().toLowerCase() ==
        cityName.toLowerCase()) {
      return CityModel(
          name: cityJSON[i]["name"].toString(),
          lat: cityJSON[i]["latitude"].toString(),
          lon: cityJSON[i]["longitude"].toString());
    }
  }
  return null;
}
