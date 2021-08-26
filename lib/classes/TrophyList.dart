import 'package:flutter/material.dart';

class Trophy{
  
  int       id;
  int       idFishery;
  String    userName;
  DateTime  date;
  Image     img;
  String    description;
}

class TrophyList{
  List<Trophy> list = new List<Trophy>();


  Trophy getFishByID(int fID){
    for (Trophy i in list) 
      if(i.id == fID)
        return i;
    
    print("Error: Fish not Found");
    return null;
  }

}