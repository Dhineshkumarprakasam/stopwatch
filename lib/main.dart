import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splash_view/source/presentation/pages/splash_view.dart';
import 'package:splash_view/source/presentation/widgets/background_decoration.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';

void main() {
  runApp(
    MaterialApp(
      home: SplashView(
        backgroundImageDecoration: BackgroundImageDecoration(
          image: AssetImage('images/splash.png'),
        ),
        done: Done(MyApp()),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int second = 0;
  int minute = 0;
  int hour = 0;
  String displaySecond = "00";
  String displayMinute = "00";
  String displayHour = "00";
  bool started = false;
  late Timer timer;
  late List stamp = [];

  TextStyle textStyle = GoogleFonts.roboto(
    fontSize: 64,
    fontWeight: FontWeight.bold,
  );

  void stopTimer() {
    if (started == true) {
      timer.cancel();
    }
    setState(() {
      started = false;
    });
  }

  void startTimer() {
    if (started == false) {
      setState(() {
        started = true;
      });
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          second++;
          if (second == 60) {
            second = 0;
            minute++;
          }
          if (minute == 60) {
            minute = 0;
            hour++;
          }
          if (second < 10) {
            displaySecond = "0$second";
          }
          if (minute < 10) {
            displayMinute = "0$minute";
          }
          if (second > 10) {
            displaySecond = "$second";
          }
          if (minute > 10) {
            displayMinute = "$minute";
          }
          if (hour < 10) {
            displayHour = "0$hour";
          }
          if (hour > 10) {
            displayHour = "$hour";
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(60, 110),
            ),
          ),
          backgroundColor: Colors.black,
          title: Text(
            "Stop Watch",
            style: GoogleFonts.abel(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 8,
                bottom: 20,
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$displayHour:$displayMinute:$displaySecond',
                    style: textStyle,
                  ),
                ],
              ),
            ),

            stamp.isNotEmpty
                ? Container(
                    width: 300,
                    height: 230,
                    child: ListView.builder(
                      itemCount: stamp.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: index % 2 == 0
                                ? Color.fromRGBO(220, 220, 220, 1)
                                : Color.fromRGBO(220, 220, 220, 0.3),
                          ),

                          child: ListTile(
                            dense: true,
                            title: Text(stamp[index]),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  stamp.removeAt(index);
                                });
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),

        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              started == false
                  ? TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        startTimer();
                      },
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                  : TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        stopTimer();
                      },
                      child: Icon(
                        Icons.stop_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

              Container(
                margin: EdgeInsets.only(bottom: 150),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: started == false
                      ? null
                      : () {
                          setState(() {
                            stamp.insert(
                              0,
                              "$displayHour:$displayMinute:$displaySecond",
                            );
                          });
                        },
                  child: Icon(Icons.flag, color: Colors.white, size: 40),
                ),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    second = 0;
                    minute = 0;
                    hour = 0;

                    displaySecond = "00";
                    displayMinute = "00";
                    displayHour = "00";
                    stamp = [];
                  });
                },
                child: Icon(Icons.refresh, color: Colors.white, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
