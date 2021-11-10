import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dataset.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'seven_hourly.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

List<Weather>? sevenDay;
List<Weather>? todayWeather;
Weather? currentTemp;
Placemark? place;

late double lat;
late double lon;
String city = _currentAddress.toString();
//int woeid = 2487956;

Position? _currentPosition;
String? _currentAddress;

//String searchApiUrl = 'https://www.metaweather.com/api/location/search/?query=';
//String locationApiUrl = 'https://www.metaweather.com/api/location/';

const Color _textColor = Colors.white;

class WeatherMainPage extends StatefulWidget {
  @override
  State<WeatherMainPage> createState() => _WeatherMainPageState();
}

class _WeatherMainPageState extends State<WeatherMainPage> {
  getData() async {
    fetchData(lat, lon, city.toString()).then((value) {
      currentTemp = value![0];
      todayWeather = value[1];
      sevenDay = value[2];
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((value) => getData());
  }

  /*initState() {
    super.initState();
    fetchLocation();
    fetchLocationDay();
  }*/

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
    setState(() {
      _currentPosition = position;
      lat = position.latitude;
      lon = position.longitude;
    });
    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.locality}";
      });
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    // print(_currentPosition!.latitude);
    // print(_currentPosition!.longitude);
    // print(_currentAddress);
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(children: [
                Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.amber.shade300, Colors.orange])),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: currentTemp == null
                              ? const CircularProgressIndicator()
                              : Text(
                                  currentTemp!.current.toString() + '\u00B0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 160,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    )),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(67.0),
                      child: Icon(
                        WeatherIcons.night_alt_cloudy,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 430, left: 65),
                      child: Text(
                        'Humidity',
                        style: TextStyle(color: Colors.white54, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 430, left: 240),
                      child: Text(
                        'Rain/Snow',
                        style: TextStyle(color: Colors.white54, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 460, left: 84),
                      child: Text(
                        currentTemp!.humidity.toString(),
                        style: TextStyle(color: Colors.white70, fontSize: 21),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 460, left: 267),
                      child: Text(
                        currentTemp!.chanceRain.toString() + '%',
                        style: TextStyle(color: Colors.white70, fontSize: 21),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 540, left: 125),
                      child: Text(
                        currentTemp!.description.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 135, top: 45),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(_currentAddress.toString(),
                                        style: GoogleFonts.montserrat(
                                            color: _textColor, fontSize: 30)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [],
                                        ),
                                        /*Text(
                                  "Feels like 24",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                )*/
                                      ],
                                    ),
                                  ),
                                  /*VerticalDivider(
                            color: Colors.white,
                          ),*/
                                ],
                              ),
                            ),

                            /*Divider(
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(
                        "Sunrise 7 AM",
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ))),
                      Expanded(
                          child: Center(
                              child: Text(
                        "Sunset 6 PM",
                        style: GoogleFonts.montserrat(color: Colors.white),
                      )))
                    ],
                  ),*/
                            /*Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: WormEffect(
                          radius: 8,
                          dotWidth: 8,
                          dotHeight: 8,
                          dotColor: Colors.white.withOpacity(.5),
                          activeDotColor: Colors.white),
                    ),
                  ),*/
                          ],
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 68),
                    child: SizedBox(
                      height: 50,
                      width: 135,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HourlyPage(todayWeather!);
                            },
                          ));
                        },
                        child: const Text('Hourly',
                            style: TextStyle(fontSize: 20)),
                        color: Colors.orange.shade200,
                        textColor: Colors.white,
                        elevation: 5,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 68),
                    child: SizedBox(
                      height: 50,
                      width: 135,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return DetailPage(sevenDay!);
                            },
                          ));
                        },
                        child: const Text('7 days',
                            style: TextStyle(fontSize: 20)),
                        color: Colors.orange.shade200,
                        textColor: Colors.white,
                        elevation: 5,
                      ),
                    ),
                  ),
                ),
              ]));
  }
}



/*Container(
              height: MediaQuery.of(context).size.height / 6,
              padding: EdgeInsets.only(top: 8, bottom: 12, left: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        WeatherIcons.day_cloudy,
                        color: Colors.white,
                        size: 38,
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "24°",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Text(
                            "NOW",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          WeatherIcons.day_cloudy,
                          color: Colors.white,
                          size: 38,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "28°",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              "10 AM",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          WeatherIcons.day_cloudy,
                          color: Colors.white,
                          size: 38,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "28°",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              "10 AM",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          WeatherIcons.day_cloudy,
                          color: Colors.white,
                          size: 38,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "28°",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              "10 AM",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          WeatherIcons.day_cloudy,
                          color: Colors.white,
                          size: 38,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "28°",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              "10 AM",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          WeatherIcons.day_cloudy,
                          color: Colors.white,
                          size: 38,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "28°",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              "10 AM",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ])))
    ]));
  }
}
                  Divider(
                    color: Colors.white,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
                    padding: EdgeInsets.only(top: 8, bottom: 12, left: 16),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Center(
                                  child: Text(
                                    "TODAY",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Icon(
                                WeatherIcons.day_cloudy,
                                color: Colors.white,
                                size: 38,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "23°-40°",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4)),
                                child: Center(
                                  child: Text(
                                    "AUG 5",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "FRI",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Icon(
                                  WeatherIcons.day_sunny,
                                  color: Colors.white,
                                  size: 38,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "23°-40°",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "AUG 6",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "SAT",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Icon(
                                  WeatherIcons.day_sunny,
                                  color: Colors.white,
                                  size: 38,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "23°-39°",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "AUG 7",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "SUN",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Icon(
                                  WeatherIcons.day_sunny,
                                  color: Colors.white,
                                  size: 38,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "19°-40°",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "AUG 8",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "FRI",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Icon(
                                  WeatherIcons.day_sunny,
                                  color: Colors.white,
                                  size: 38,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "23°-40°",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "AUG 6",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "FRI",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Icon(
                                  WeatherIcons.day_sunny,
                                  color: Colors.white,
                                  size: 38,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "23°-40°",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      "AUG 6",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
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
}*/
