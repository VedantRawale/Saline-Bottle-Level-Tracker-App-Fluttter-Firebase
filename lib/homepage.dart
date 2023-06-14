import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:saline_detector_app/addcarddialog.dart';
import 'package:saline_detector_app/bottle.dart';
import 'package:saline_detector_app/glassview.dart';
import 'package:saline_detector_app/fitness_theme.dart';
import 'package:saline_detector_app/wave_view.dart';
import 'package:lottie/lottie.dart';
import 'package:saline_detector_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ElevatedCard> cards = [];
  int number = 0;
  int index = 0;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body!),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Saline Level Tracker '),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => {}, icon: const Icon(Icons.search)),
              IconButton(
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCardDialog(index: index),
                            )).then((value) {
                          if (value != null) {
                            setState(() {
                              cards.add(value);
                              index++;
                              number++;
                            });
                          }
                        }),
                      },
                  icon: const Icon(Icons.add)),
            ],
          )
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.blueGrey,
      body: ListView.builder(
        itemCount: number,
        physics: ScrollPhysics(parent: null),
        itemBuilder: (context, index) {
          return cards[index];
        },
      ),
    );
  }
}

final rgn = [];
final patientname = [];

class ElevatedCard extends StatefulWidget {
  final int cardId;
  final String patientName;
  final String rgnumber;
  const ElevatedCard(
      {super.key,
      required this.cardId,
      required this.patientName,
      required this.rgnumber});

  @override
  _ElevatedCardState createState() => _ElevatedCardState();
}

class _ElevatedCardState extends State<ElevatedCard> {
  double percentage = 45.0;
  late StreamSubscription<DatabaseEvent> percentageSubscription;
  @override
  void initState() {
    super.initState();
    listenForPercentageData();
  }

  @override
  void dispose() {
    percentageSubscription.cancel();
    super.dispose();
  }

  void listenForPercentageData() {
    final databaseReference = FirebaseDatabase.instance.ref('cards');
    percentageSubscription = databaseReference
        .child((widget.cardId + 1).toString())
        .child('percentage')
        .onValue
        .listen((DatabaseEvent event) {
      // Update this line
      final value = event.snapshot.value;
      if (value != null) {
        if (value is double) {
          setState(() {
            percentage = value;
          });
          if (value < 5.0) {
            _showAlertNotification();
          }
        } else if (value is int) {
          setState(() {
            percentage = value.toDouble();
          });
          if (value < 5) {
            _showAlertNotification();
          }
        }
      }
    });
  }

  Future<void> _showAlertNotification() async {
    flutterLocalNotificationsPlugin.show(
        0,
        "Saline Level Alert",
        "The saline bottle for Bed ${(widget.cardId + 1)} is about to empty!",
        NotificationDetails(
          android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          color:Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher'
        ))
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 58),
      child: Container(
        decoration: BoxDecoration(
          color: FitnessAppTheme.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: FitnessAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 18),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 3),
                              child: Text(
                                'BED',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 8),
                              child: Text(
                                (widget.cardId + 1).toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                  letterSpacing: -0.2,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4, top: 2, bottom: 14),
                          child: Text(
                            "Patient name: " + widget.patientName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.0,
                              color: FitnessAppTheme.darkText,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4, top: 2, bottom: 14),
                          child: Text(
                            'RGN.no :' + widget.rgnumber,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: Colors.redAccent
                                // color: FitnessAppTheme.darkText,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, top: 8, bottom: 16),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.background,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.access_time,
                                  color: FitnessAppTheme.grey.withOpacity(0.5),
                                  size: 16,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  'Last dose 8:26 AM',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    color:
                                        FitnessAppTheme.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: LottieBuilder.asset(
                                    'android/assets/medicine3.json',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    ' Checkup time!..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      color: HexColor('#F65283'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, top: 16),
                child: Container(
                  width: 60,
                  height: 160,
                  decoration: BoxDecoration(
                    color: HexColor('#E8EDFE'),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(80.0),
                        bottomLeft: Radius.circular(80.0),
                        bottomRight: Radius.circular(80.0),
                        topRight: Radius.circular(80.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey.withOpacity(0.4),
                          offset: const Offset(2, 2),
                          blurRadius: 4),
                    ],
                  ),
                  child: WaveView(
                    percentageValue: percentage,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
