import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app4/dataset.dart';
import 'package:flutter/material.dart';
import 'package:weather_app4/weather_main_page.dart';

class DetailPage extends StatelessWidget {
  final List<Weather> sevenDay;

  DetailPage(
    this.sevenDay,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent, 
        elevation: 0,
        title: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "This week's weather",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: Column(
        children: [SevenDays(sevenDay)],
      ),
    );
  }
}

class HourlyPage extends StatelessWidget {
  final List<Weather> hourly;

  HourlyPage(this.hourly);

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "24h Weather",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      backgroundColor: Color(0xff030317),
      body: Column(
        children: [Hourly(hourly)],
      ),
    );
  }
}

class Hourly extends StatelessWidget {
  List<Weather> hourly;
  List<Weather>? todayWeather;

  Hourly(this.hourly);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.amber.shade300, Colors.orange])),
      child: ListView.builder(
        itemCount: hourly.length,
        itemBuilder: (BuildContext context, int index) {
          return Align(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 50,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: Text(
                      hourly[index].time.toString(),
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 5),
                    child: Text(
                      hourly[index].description.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                  ),

                  /*child: RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: hourly[index].time.toString(),
                            style: TextStyle(fontSize: 30, color: Colors.white70)),
                            TextSpan(text: hourly[index].description.toString())
                          ]),
                    ),*/
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          hourly[index].current.toString() + '\u00B0',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

//Image(
//image: AssetImage(sevenDay[index].image.toString()),
//width: 40,
//),
// SizedBox(width: 15),
//Text(
//sevenDay[index].name.toString(),
//style: TextStyle(fontSize: 20),
//),

class SevenDays extends StatelessWidget {
  List<Weather> sevenDay;

  SevenDays(this.sevenDay);

  String? _currentAddress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.amber.shade300, Colors.orange])),
      child: ListView.builder(
        itemCount: sevenDay.length,
        itemBuilder: (BuildContext context, int index) {
          return Align(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 50,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 78),
                    child: Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              sevenDay[index].max.toString() + '\u00B0',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        sevenDay[index].day.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

//Text(
                      //'+' + sevenDay[index].min.toString() + '\u00B0',
                      //style: TextStyle(fontSize: 20, color: Colors.grey),
                      //),

                      /*SingleChildScrollView(
                    child: Container(
                      width: 135,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Image(
                          //image: AssetImage(sevenDay[index].image.toString()),
                          //width: 40,
                          //),
                          // SizedBox(width: 15),
                          //Text(
                          //sevenDay[index].name.toString(),
                          //style: TextStyle(fontSize: 20),
                          //),
                        ],
                      ),
                    ),
                  ),*/
