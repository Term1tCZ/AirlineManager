import 'package:flutter/material.dart';

import 'package:kiwi/models/offer.dart';
import './screens/offers_overview_screen.dart';
import './screens/flight_screen.dart';
import './screens/main_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Airline Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainOverviewScreen(),
      routes: {
        OffersOverviewScreen.routeName: (ctx) => OffersOverviewScreen(),
        //FlightScreen.routeName: (ctx) => FlightScreen(),
      },
    );
  }
}
