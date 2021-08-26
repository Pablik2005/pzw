import 'package:flutter/material.dart';

class Alert{
  
  int       id;
  int       idFishery;
  Image     img;
  DateTime  startDate;
  String    time;
  String    type;
  String    content;
}

class AlertList{
  List<Alert> list = new List<Alert>();


  Alert getFishByID(int fID){
    for (Alert i in list) 
      if(i.id == fID)
        return i;
    
    print("Error: Alert not Found");
    return null;
  }

}