import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:pzw/classes/FisheryList.dart';
import 'package:pzw/warehouse.dart';
import 'package:pzw/classes/Loader.dart';

class FisheryListView extends StatefulWidget {
  @override
  _FisheryListStateView createState() => new _FisheryListStateView();
}

class _FisheryListStateView extends State<FisheryListView> {
  List<int> _search = [];
  TextEditingController _searchKey = new TextEditingController(text: "");

  List<Widget> fisheryListView = new List<Widget>();

  Icon _loginIcon = new Icon(Icons.person_add);
  Icon _logoutIcon = new Icon(Icons.person);
  Icon _loginStatusIcon = new Icon(Icons.person_add);
  IconButton _loginState;

  Loader  _refreshFisheryList = new Loader();

  String _userName;

  @override
  void initState() {

    _refreshFisheryList.setHeigh(30.0);
    //generateFisheryListView("");
    for (Fishery i in Warehouse.fisheryList.list) 
      fisheryListView.add( generateRowLayout(i) );

    loadAccount().then((val) {
      if (Warehouse.isLogin) {
        _userName = Warehouse.user.email;
        _loginStatusIcon = _logoutIcon;
        setState(() {});
      }else{
        _userName = "Gość";
        _loginStatusIcon = _loginIcon;
        setState(() {});
      } 
    });

    if (Warehouse.isLogin) {
      _userName = Warehouse.user.email;
      _loginStatusIcon = _logoutIcon;
    }else{
      _userName = "Gość";
      _loginStatusIcon = _loginIcon;
    } 

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          _refreshFisheryList.finish();            
        });

        
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PZW',
      home: Scaffold(
        appBar: AppBar(
          title: Text(_userName),
          actions: <Widget>[

            //Refresh
            new IconButton(
              icon: _refreshFisheryList,
              onPressed: (){
                _refreshFisheryList.start();
                Warehouse.getFishListFromDB()
                .then((_){
                  Warehouse.getFisheryListFromDB()
                  .then((_){
                    fisheryListView.clear();
                    for (Fishery i in Warehouse.fisheryList.list) 
                      fisheryListView.add( generateRowLayout(i) );
                    generateFisheryListView("");
                    _refreshFisheryList.finish();
                  });
                });
              },
            ),

            //Login
            _loginState = new IconButton(
              icon: _loginStatusIcon,
              onPressed: () {
                loginStatePressed();
              },
            ),

          ],
        ),

        body: new Container(
          child: new Column(
            children: <Widget>[

              //Search
              new ListTile(
                leading: new Icon(Icons.search),
                title: new TextField(
                  controller: _searchKey,
                  onChanged: generateFisheryListView,
                  decoration: new InputDecoration(
                      hintText: 'Wyszukaj', border: InputBorder.none),
                ),
                trailing: new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed: () {
                    _searchKey.clear();
                    generateFisheryListView("");
                  },
                ),
              ),

              //FisheryList
              new Expanded(
                  child: _search.length != 0 || _searchKey.text.isNotEmpty
                       ? new ListView.builder(
                           itemCount: _search.length,
                           itemBuilder: (context, i) {
                             return fisheryListView.elementAt( _search[i] );
                           })
                       : new ListView.builder(
                           itemCount: fisheryListView.length,
                           itemBuilder: (context, i) {
                            return fisheryListView.elementAt(i);
                           })
              ),

            
            ],
          ),
        ),
      ),
    );
  }

  void generateFisheryListView(String key) async {
    _search.clear();

    if(_searchKey.text.isNotEmpty)  
    for (var i = 0; i < Warehouse.fisheryList.list.length; i++) {
      if ( Warehouse.fisheryList.list.elementAt(i).name.toLowerCase().contains(key.toLowerCase())) 
          _search.add(i);
    }
    
    setState(() {});
  }

  Container generateRowLayout(Fishery fFishery) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[

          //Nazwa
          new Center(
            child: Text(
              fFishery.name,
              style: new TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 20.0
              ),
            ),
          ),
 

          //Mapa
          new RaisedButton(
            child: fFishery.img,
            onPressed: () {
              Warehouse.selectedFishery = fFishery;
              if (fFishery.isFull)
                Navigator.of(context).pushNamed('FisheryView');
              else{
                _refreshFisheryList.start();
                Warehouse.getFullFisheryData(fFishery.id).then((val) {
                  _refreshFisheryList.finish();
                  fFishery.isFull = true;
                  Navigator.of(context).pushNamed('FisheryView');
                });
              }

            },
          ),

          //Nawiguj do
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              //Parkingi
              new RaisedButton(
                child: Text("Nawiguj do .."),
                onPressed: fFishery.parkingPlacesList.list.length != 0
                    ? () {
                        Warehouse.selectedFishery = fFishery;
                        Navigator.of(context).pushNamed('ParkingPlaceListView');
                      }
                    : null,
              ),

            ],
          )
        ],
      ),
    );
  }

  String markTheMeasureOfFishery(String fCoordinates) {
    List<String> tCoordinates = fCoordinates.split(';');

    double latMax =
        double.parse(tCoordinates.elementAt(0).split('-').elementAt(0));
    double latMin =
        double.parse(tCoordinates.elementAt(0).split('-').elementAt(0));
    double longMax =
        double.parse(tCoordinates.elementAt(0).split('-').elementAt(1));
    double longMin =
        double.parse(tCoordinates.elementAt(0).split('-').elementAt(1));

    for (String i in tCoordinates) {
      double tLat = double.parse(i.split('-').elementAt(0));
      double tLong = double.parse(i.split('-').elementAt(1));

      if (latMin > tLat) latMin = tLat;
      if (latMax < tLat) latMax = tLat;
      if (longMin > tLong) longMin = tLong;
      if (longMax < tLong) longMax = tLong;
    }

    double tLatAverage = (latMax + latMin) / 2;
    double tLongAverage = (longMax + longMin) / 2;

    return tLatAverage.toString() + "," + tLongAverage.toString();
  }

  void loginStatePressed() async {

    if(!Warehouse.isLogin)
      Navigator.of(context).pushNamed('LoginView');
    else
    {
      Warehouse.isLogin = false;
      Warehouse.user.id = "";
      Warehouse.user.email = "";
      Warehouse.user.password = "";

      Directory tDirectory = await getApplicationDocumentsDirectory();
        File tFile = new File(tDirectory.path + '/user.data');
        if(tFile.existsSync())
          tFile.deleteSync();
      Navigator.of(context).pushNamed('FisheryListView');
    }
  }

  Future<bool> loadAccount() async {
    Directory tDirectory = await getApplicationDocumentsDirectory();
    File tFile = new File(tDirectory.path + '/user.data');
    if (tFile.existsSync()) {
      List<String> tList = tFile.readAsStringSync().split(';');
      if (tList.length != 0) {
        Warehouse.isLogin = true;
        Warehouse.user.id = tList.elementAt(0);
        Warehouse.user.email = tList.elementAt(1);
        Warehouse.user.password = tList.elementAt(2);
        return true;
      }
      return false;
    } else
      return false;
  }
}



                  // child: _search.length != 0 || _searchKey.text.isNotEmpty
                  //      ? new ListView.builder(
                  //          itemCount: _search.length,
                  //          itemBuilder: (context, i) {
                  //            return generateRowLayout(Warehouse.fisheryList.list.elementAt( _search[i] ));
                  //          })
                  //      : new ListView.builder(
                  //          itemCount: Warehouse.fisheryList.list.length,
                  //          itemBuilder: (context, i) {
                  //           return generateRowLayout(Warehouse.fisheryList.list[i]);
                  //          })

    // if(_searchKey.text.isNotEmpty)  
    //   for (var i in Warehouse.fisheryList.list)
    //     if (i.name.toLowerCase().contains(key.toLowerCase())) _search.add(i);