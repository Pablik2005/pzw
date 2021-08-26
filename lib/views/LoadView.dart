import 'package:flutter/material.dart';

import 'package:pzw/warehouse.dart';
import 'package:pzw/classes/Loader.dart';

class LoadView extends StatefulWidget {
  @override
  _LoadViewStateView createState() => new _LoadViewStateView();
}

class _LoadViewStateView extends State<LoadView> {

  Loader _loader = new Loader();

  @override
  void initState(){
    super.initState();

    _loader.setHeigh(60.0);

    Warehouse.getFishListFromDB()
    .then((val){
      Warehouse.getFisheryListFromDB()
      .then((val){
        _loader.finish();
        Navigator.of(context).pushNamedAndRemoveUntil('FisheryListView', (Route<dynamic> route) => false);
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PZW'),
      ),
      body: new Center(
        child: new Container(
          decoration: new BoxDecoration(color: Colors.blue),
          child: new ListView(
            children: <Widget>[

              new Container(
                  margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 5.0),
                  child: new Image(
                    image: new AssetImage("assets/logo.ico"),
                  ),
              ),

              new Center(
                child: new Text(
                  "Pobierania Łowisk:",
                  style: new TextStyle(
                    fontSize: 20.0,
                  )
                )
              ),

              new Container(
                margin: EdgeInsets.only(top: 20.0),
                child: _loader,
              )
              
              
            ],
          ),
        ),
      ),
    );
  }

  
}
