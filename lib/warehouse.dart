import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'classes/FishList.dart';
import 'classes/FisheryList.dart';
import "classes/ParkingPlaceList.dart";
import "classes/AlertList.dart";
import 'classes/TrophyList.dart';


class User{
  String id;
  String email;
  String password;
}

class Warehouse {
  static String _host = "http://80.48.28.252:3001/";

  static FisheryList _fisheryList = new FisheryList();
  static FisheryList get fisheryList => _fisheryList;
  static void set fisheryList(FisheryList fFisheryList) => _fisheryList = fFisheryList;

  static Fishery _selectedFishery;
  static Fishery get selectedFishery => _selectedFishery;
  static void set selectedFishery(Fishery fFishery) => _selectedFishery = fFishery;

  static Alert _selectedAlert;
  static Alert get selectedAlert => _selectedAlert;
  static void set selectedAlert(Alert fAlert) => _selectedAlert = fAlert;

  static FishList _fishList = new FishList();
  static FishList get fishList => _fishList;
  static void set fishList(FishList fFishList) => _fishList = fFishList;

  static Image _selectedImage;
  static Image get selectedImage => _selectedImage;
  static void set selectedImage(Image fImage) => _selectedImage = fImage;

  static bool _isLogin = false;
  static bool get isLogin => _isLogin;
  static void set isLogin(bool fIsLogin) => _isLogin = fIsLogin;

  static User _user = new User();
  static User get user => _user;
  static void set user(User fUser) => _user = fUser;

  static Future<List<String>> tryLogin(String fEmail, String fHash) async
  {
    var response = await http.post(
      _host + "tryLogin", 
      headers: {'Content-type' : 'application/json', 'Accept': 'application/json'},
      body: json.encode({'email' : fEmail, 'hash': fHash})
    ); 
    var res = jsonDecode(response.body);

    List<String> returnList = new List<String>();
    if(res['id'] != null)
    {
      returnList.add( "id" );
      returnList.add( res['id'] );
      return returnList;
    }else
    {
      returnList.add( "error" );
      returnList.add( res['error'] );
      return returnList;
    }

  } 

  static Future<Null> getFishListFromDB() async {

    _fishList.list.clear();

    var response = await http.post(_host + "getFishList", body: {});
    var tFishes = jsonDecode(response.body);

    for (var i in tFishes) {
      Fish tFish = new Fish();
      tFish.id = i['id'];
      tFish.name = i['name'];
      tFish.type = i['type'];
      tFish.protectiveDimension = i['protectiveDimension'];

      if (i['img'] != null) 
        tFish.img = new Image.memory(
          base64.decode( getImageFormJSON(i['img'])),
          height: 80.0,
          width: 100.0,
        );

      _fishList.list.add(tFish);
    }
  }


  static Future<Null> getFisheryListFromDB() async {

    _fisheryList.list.clear();

    var response = await http.post(_host + "getFisheryList", body: {});
    var tUsers = jsonDecode(response.body);

    for (var i in tUsers) {
      Fishery tFishery = new Fishery();
      tFishery.id = i['id'];
      tFishery.name = i['name'];
      tFishery.coordinates = i['coordinates'];
      tFishery.supervisor = i['supervisor'];
      tFishery.googlemapURL = i['googlemapURL'];
      tFishery.characteristic = i['characteristic'];
      tFishery.regulations = i['regulations'];



      if (i['img'] != null) 
        tFishery.img = new Image.memory(
          base64.decode( getImageFormJSON(i['img'])),
          );

      if (i['bathymetryMap'] != null) 
        tFishery.bathymetryMap = new Image.memory(
          base64.decode( getImageFormJSON(i['bathymetryMap'])),
          );
      
      _fisheryList.list.add(tFishery);
    }

    response = await http.post(_host + "getParkingPlaceList", body: {});
    var tParkingPlaces = jsonDecode(response.body);

    for (var i in tParkingPlaces) {
      ParkingPlace tParking = new ParkingPlace();
      tParking.id = i['id'];
      tParking.idFishery = i['idFishery'];
      tParking.name = i['name'];
      tParking.coordinate = i['coordinate'];

      if (i['img'] != null) 
        tParking.img = new Image.memory(
          base64.decode( getImageFormJSON(i['img'])),
          );

      _fisheryList
          .getFisheryByID(tParking.idFishery)
          .parkingPlacesList
          .list
          .add(tParking);
    }
  }

  static Future<Null> getFishListFromFishery(int fFisheryID) async {

    Warehouse.fisheryList.getFisheryByID(fFisheryID).fishList.list.clear();
 

    var response = await http.post(
      _host + "getFishListFromFishery", 
      headers: {'Content-type' : 'application/json', 'Accept': 'application/json'},
      body: json.encode({'idFishery' : fFisheryID})
    ); 
    var tFishesID = jsonDecode(response.body);

    for (var i in tFishesID){
      Warehouse.fisheryList.getFisheryByID(fFisheryID).fishList.list.add( Warehouse.fishList.getFishByID( i['idFish']) );
    }
  }

  static Future<Null> getAlertListFromFishery(int fFisheryID) async {

    Warehouse.fisheryList.getFisheryByID(fFisheryID).alertList.list.clear();

    var response = await http.post(
      _host + "getAlertListFromFishery", 
      headers: {'Content-type' : 'application/json', 'Accept': 'application/json'},
      body: json.encode({'idFishery' : fFisheryID})
    ); 
    var tAlertList = jsonDecode(response.body);

    for (var i in tAlertList){

      Alert tAlert = new Alert();
      tAlert.id = i['id'];
      tAlert.idFishery = i['idFishery'];
      tAlert.startDate = DateTime.parse( i['startDate'] );
      tAlert.time = i['time'];
      tAlert.type = i['type'];
      tAlert.content = i['content'];

      if (i['img'] != null) 
        tAlert.img = new Image.memory(
          base64.decode( getImageFormJSON(i['img'])),
          );
      Warehouse.fisheryList.getFisheryByID(fFisheryID).alertList.list.add( tAlert );
    }
  }

  static Future<Null> getTrophyListFromFishery(int fFisheryID) async {

    Warehouse.fisheryList.getFisheryByID(fFisheryID).trophyList.list.clear();

    var response = await http.post(
      _host + "getTrophyListFromFishery", 
      headers: {'Content-type' : 'application/json', 'Accept': 'application/json'},
      body: json.encode({'idFishery' : fFisheryID})
    ); 
    var tTrophyList = jsonDecode(response.body);

    for (var i in tTrophyList){
      Trophy tTrophy = new Trophy();
      tTrophy.id = i['id'];
      tTrophy.idFishery = i['idFishery'];
      tTrophy.userName = i['idUser'];
      tTrophy.date = DateTime.parse( i['date'] );
      tTrophy.description = i['description'];

      if (i['img'] != null) 
        tTrophy.img = new Image.memory(
          base64.decode( getImageFormJSON(i['img'])),
          );
      Warehouse.fisheryList.getFisheryByID(fFisheryID).trophyList.list.add( tTrophy );
    }
  } 

  static Future<Null> getFullFisheryData(int fFisheryID) async {
    await getFishListFromFishery(fFisheryID);
    await getAlertListFromFishery(fFisheryID);
    await getTrophyListFromFishery(fFisheryID);
  }

  static String getImageFormJSON(var fJSON) {
    var tIMG = fJSON;
    List<dynamic> tListDynamic = tIMG['data'];
    List<int> tListInt = [];
    for (var i in tListDynamic) tListInt.add(i);
    
    return  ascii.decode(tListInt);
  }

  static Future<Null> addTrophy(int fFIsheryID, String fUserID, var fIMG, String fDescription)async{
    await http.post(
      _host + "addTrophy", 
      headers: {'Content-type' : 'application/json', 'Accept': 'application/json'},
      body: json.encode({
        'idFishery' : fFIsheryID, 
        'idUser' :  fUserID,
        'img' : fIMG,
        'description' : fDescription
      })
    ); 
  }

  static Future<Null> addNotification(int fFIsheryID, String fUserID, String fType, String fLatitude, String fLongitude , String fContent, var fIMG)async{
    await http.post(
      _host + "addNotification", 
      headers: {'Content-type' : 'application/json', 'Accept': 'application/json'},
      body: json.encode({
        'idFishery' : fFIsheryID, 
        'idUser' :  fUserID,
        'type' : fType,
        'latitude' : fLatitude,
        'longitude' : fLongitude,
        'content' : fContent,
        'img' : fIMG
      })
    ); 
  }

  static Future<String> addUser( String fEmial, String fPassword, String fName, String fSurname, String fAddress, String fPostOffice, String fMobilePhone, String fLandlinePhone, String fFishingCardNumber) async {
    var res = await http.post(
      _host + "addUser", 
      headers: {'Content-type' : 'application/json', 'Accept': 'application/json'},
      body: json.encode({
        'email' : fEmial, 
        'password' :  fPassword,
        'name' : fName,
        'surname' : fSurname,
        'address' : fAddress,
        'postOffice' : fPostOffice,
        'mobilePhone' : fMobilePhone,
        'landlinePhone' : fLandlinePhone,
        'fishingCardNumber' : fFishingCardNumber
      })
    ); 

    String tIDs = jsonDecode(res.body).toString();
    String key = tIDs.split(":").elementAt(0).substring(1,3);
    String value = tIDs.split(":").elementAt(1).substring(1,33);

    if(key == 'id')
      return value;
    else
      return "";
  }

  static saveAccountData(String fID, String fEmail, String fPassword) async {
    Directory tDirectory = await getApplicationDocumentsDirectory();
    File tFile = new File(tDirectory.path + '/user.data');
    tFile.writeAsStringSync(fID+";"+fEmail+";"+fPassword);
    return true;
  }
}
