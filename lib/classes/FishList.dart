import 'package:flutter/material.dart';

class Fish{
  
  int     id;
  String  name;
  String  type;
  Image   img;
  int     protectiveDimension;
}

class FishList{
  List<Fish> list = new List<Fish>();


  Fish getFishByID(int fID){
    for (Fish i in list) 
      if(i.id == fID)
        return i;
    
    print("Error: Fish not Found");
    return null;
  }

}