import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import 'package:pzw/warehouse.dart';
import 'package:pzw/classes/FishList.dart';
import 'package:pzw/classes/AlertList.dart';
import 'package:pzw/classes/TrophyList.dart';

class FisheryView extends StatefulWidget {
  @override
  _FisheryViewStateView createState() => new _FisheryViewStateView();
}

class _FisheryViewStateView extends State<FisheryView> {

  bool _contentON = false;
  bool _lockButton = false;
  String _alertType = null;
  List<String> _alertTypes = new List<String>();
  final TextEditingController _imgTag = new TextEditingController(text: "Brak");
  final TextEditingController _content = new TextEditingController();

  File _imageFile;
  getImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if(_imageFile != null)
        _imgTag.text = "Dodano";
    });
  }

  void _alertTypeOnChange(String value){
    setState((){
    _alertType = value;
    });
  }

  @override
  void initState() {
    _alertTypes.add("Kłusownictwo");
    _alertTypes.add("Zaśmiecanie");
    _alertTypes.add("Inne..");
    _alertType = _alertTypes.elementAt(0);

    _content.addListener((){
      setState(() {
        if(_content.text.isNotEmpty)
          _contentON = true;
        else
          _contentON = false;        
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var _buttonSendNotification;
    if(_contentON && !_lockButton && Warehouse.isLogin)
      _buttonSendNotification = () async {
        setState(() {
          _lockButton = true;          
        });

        var tBase64="";
        if(_imgTag.text != "Brak")
          tBase64 = base64.encode( _imageFile.readAsBytesSync() );
        
        Position position = await Geolocator().getCurrentPosition(LocationAccuracy.high);

        Warehouse.addNotification(
          Warehouse.selectedFishery.id, 
          Warehouse.user.id,
          _alertType,
          position.latitude.toString(),
          position.longitude.toString(),
          _content.text,
          tBase64)
        .then((val){

          _imageFile = null;
          _imgTag.text = "Brak";
          _content.text = "";
          
          setState(() {
            _lockButton = false;          
          });
          
        });
      };


    return DefaultTabController(
      length: 6,
      child: new Scaffold(
        appBar: AppBar(
          title: Text(Warehouse.selectedFishery.name),
          actions: <Widget>[],
          bottom: new TabBar(
            isScrollable: true,
            tabs: [
              new Tab(
                child: new Text("Łowisko"),
              ),
              new Tab(
                child: new Text("Batymetria"),
              ),
              new Tab(
                child:  new Text("Regulamin"),
              ),
              new Tab(
                text: "Ostrzeżenia i powiadomienia",
              ),
              new Tab(
                text: "Złowione ryby",
              ),
              new Tab(
                text: "Zgłoszenia naruszeń",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [

            //Fishery
            new Container(
              margin: EdgeInsets.only(top: 10.0),
              child: new Column(
                children: <Widget>[

                  //Opiekun
                  new Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      "Opiekun :  " + Warehouse.selectedFishery.supervisor,
                      style: new TextStyle(
                        fontSize: 20.0,
                        
                      ),
                    ),
                  ),

                  //Zdjęcie łowiska
                  new RaisedButton(
                    child: Warehouse.selectedFishery.img,
                    onPressed: (){
                      Warehouse.selectedImage = Warehouse.selectedFishery.img;
                      Navigator.of(context).pushNamed('ImageView');
                    },
                  ),

                  //Characteristic
                  new TextField(
                    controller: new TextEditingController(text: Warehouse.selectedFishery.characteristic),
                    maxLines: 5,
                  ),

                  //Ryby
                  new Container(
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: new Text(
                      "Występujące Ryby :",
                      style: new TextStyle(
                        fontSize: 20.0
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new ListView.builder(
                      itemCount: Warehouse.selectedFishery.fishList.list.length,
                      itemBuilder: (context, i) {
                        return generateFishRowLayout(Warehouse
                            .selectedFishery.fishList.list
                            .elementAt(i));
                      },
                    ),
                  )
                ],
              ),
            ),

            //Bathymetry
            new ListView(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: new RaisedButton(
                    child: Warehouse.selectedFishery.bathymetryMap,
                    onPressed: (){
                      Warehouse.selectedImage = Warehouse.selectedFishery.bathymetryMap;
                      Navigator.of(context).pushNamed('ImageView');
                    },
                  )
                ),
              ],
            ),

            //Regulations
            new Container(
              child: new TextField(
                controller: new TextEditingController(text: Warehouse.selectedFishery.regulations),
                maxLines: 25,
              ),
            ),

            //Alerts
            new Container(
                child: ListView.builder(
                  itemCount: Warehouse.selectedFishery.alertList.list.length,
                  itemBuilder: (context, i) {
                    return generateAlertRowLayout(
                        Warehouse.selectedFishery.alertList.list.elementAt(i));
                  },
                )),

            //Trophies
            new Scaffold(
                body: new Column(
                  children: <Widget>[
                    new Expanded(
                      child: new ListView.builder(
                        itemCount:
                            Warehouse.selectedFishery.trophyList.list.length,
                        itemBuilder: (context, i) {
                          return generateTrophyRowLayout(Warehouse
                              .selectedFishery.trophyList.list
                              .elementAt(i));
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButton: Warehouse.isLogin
                    ? new FloatingActionButton(
                        child: new Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).pushNamed('AddTrophyView');
                        },
                      )
                    : null),

            //Powiadom
            new Container(
              padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: new ListView(
                children: <Widget>[

                  //Typ Alarmu
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text("Typ alarmu: "),
                      new DropdownButton(
                        value: _alertType,
                        items: _alertTypes.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          _alertTypeOnChange(value);
                        },
                      ),
                    ],
                  ),

                  //Zdjęcie
                  new Container(
                    padding: new EdgeInsets.only(top: 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text("Zdjęcie :"),
                        new Text('<' + _imgTag.text + '>'),
                        new IconButton(
                          icon: new Icon(Icons.add_a_photo),
                          onPressed: getImage,
                        )
                      ],
                    ),
                  ),

                  // Zawartość
                  new TextField(
                    controller: _content,
                    maxLines: 6,
                    decoration: new InputDecoration(
                      hintText: 'Opis',
                    )
                  ),

                    // Send Button
                    new Container(
                      padding: new EdgeInsets.only(top: 10.0),
                      child: new RaisedButton(
                        child: new Text("Wyślij"),
                        onPressed: _buttonSendNotification,
                      ),
                    ),
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }

  Container generateFishRowLayout(Fish fFish) {
    return new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Column(
            children: <Widget>[
              //Nazwa
              new Text(
                fFish.name,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0
                ),
              ),

              //Zdjęcie
              fFish.img,
            ],
          ),

          new Column(
            children: <Widget>[
              //Typ
              new Text(
                "Typ: ${fFish.type}",
                style: new TextStyle(
                  fontSize: 15.0
                ),
              ),

              //Rozmiar
              new Text(
                "Min Rozmiar: ${fFish.protectiveDimension.toString()} cm",
                style: new TextStyle(
                  fontSize: 15.0
                ),
              ),
            ],
          )
          
        ],
      ),
    );
  }

  Container generateAlertRowLayout(Alert fAlert) {
    return new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0.0, 20.0,0.0, 0.0),
      child: new Column(
        children: <Widget>[

          //Nazwa
          new Text(
            fAlert.type,
            style: new TextStyle(
              fontSize: 20.0
            ),
          ),

          //Data i czas
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Text(
                "Data : ${fAlert.startDate.toString().substring(0, 16)}",
                style: new TextStyle(
                  fontSize: 16.0
                ),
              ),

              new Text(
                "Czas : ${fAlert.time}",
                style: new TextStyle(
                  fontSize: 16.0
                ),
              ),

            ],
          ),

          //Img
          new RaisedButton(
            child: fAlert.img,
            onPressed: (){
              Warehouse.selectedImage = fAlert.img;
              Navigator.of(context).pushNamed("ImageView"); 
            },
          ),

          //Text
          new TextField(
            enabled: false,
            maxLines: 4,
            controller: new TextEditingController(text:  "Opis: "+fAlert.content),
          ),
          
        ],
      ),
    );
  }

  Container generateTrophyRowLayout(Trophy fTrophy) {
    return new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Text(
                fTrophy.userName,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),
              ),

              new Text(
                "Data: " + fTrophy.date.toString().substring(0, 16),
                style: new TextStyle(
                  fontSize: 18.0
                ),
              ),
            ],
          ),
          new RaisedButton(
            child: fTrophy.img,
            onPressed: (){
              Warehouse.selectedImage = fTrophy.img;
              Navigator.of(context).pushNamed("ImageView");
            },
          ),
          new TextField(
            controller: new TextEditingController(text: fTrophy.description),
            maxLines: 4,
            enabled: false,
          )
        ],
      ),
    );
  }
}
