import 'package:flutter/material.dart';
import 'views/LoginView.dart';
import 'views/RegistrationView.dart';
import 'views/FisheryView.dart';
import 'views/FisheryListView.dart';
import 'views/ParkingPlaceListView.dart';
import 'views/AlertView.dart';
import 'views/AddTrophyView.dart';
import "views/LoadView.dart";
import 'views/ImageView.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation',
      routes: <String, WidgetBuilder>{
        'FisheryListView': (BuildContext contet) => new FisheryListView(),
        'ParkingPlaceListView' : (BuildContext contet) => new ParkingPlaceListView(),
        'AlertView' : (BuildContext content) => new AlertView(),
        'LoginView': (BuildContext contet) => new LoginView(),
        'RegistrationView': (BuildContext context) => new RegistrationView(),
        'FisheryView': (BuildContext context) => new FisheryView(),
        'AddTrophyView': (BuildContext context) => new AddTrophyView(),
        'LoadView' : (BuildContext context) => new LoadView(),
        'ImageView' : (BuildContext context) => new ImageView(),
      },
      home: new LoadView(),      
    );
  }
}