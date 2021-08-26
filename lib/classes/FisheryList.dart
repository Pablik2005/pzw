import 'package:flutter/material.dart';

import 'ParkingPlaceList.dart';
import 'FishList.dart';
import 'AlertList.dart';
import 'TrophyList.dart';

class Fishery{
  
  int     id;
  String  name;
  String  coordinates;
  Image   img;
  String  supervisor;
  Image   bathymetryMap;
  String  googlemapURL;
  String  characteristic;
  String  regulations;

  ParkingPlaceList  parkingPlacesList = new ParkingPlaceList();
  FishList          fishList = new FishList();
  AlertList         alertList = new AlertList();
  TrophyList        trophyList = new TrophyList();

  //App Atribute
  bool   isFull = false;

}

class FisheryList{
  List<Fishery> list = new List<Fishery>();


  Fishery getFisheryByID(int fID){
    for (Fishery i in list) 
      if(i.id == fID)
        return i;
    
    print("Error: Fishery not Found");
    return null;
  }

}