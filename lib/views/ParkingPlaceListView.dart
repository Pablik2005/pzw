import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pzw/warehouse.dart';

class ParkingPlaceListView extends StatefulWidget {
  @override
  _ParkingPlaceListStateView createState() => new _ParkingPlaceListStateView();
}

class _ParkingPlaceListStateView extends State<ParkingPlaceListView> {

  int   _selected = 0;
  Image _img = new Image( image: new AssetImage("assets/logo.ico"));

  @override
  void initState(){
    if(Warehouse.selectedFishery.parkingPlacesList.list.length != 0)
      _img = Warehouse.selectedFishery.img;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Warehouse.selectedFishery.name),
      ),
      body: new Container(
        margin: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
        child: new Column(
          children: <Widget>[
            _img,
            new Column(
              children: generate()
            ),
            new RaisedButton(
              child: new Text("Nawiguj"),
              onPressed: (){ 
                if(_selected==0)
                {
                  launch(Warehouse.selectedFishery.googlemapURL); 

                }else{
                  List<String> tCoordinate = Warehouse.selectedFishery.parkingPlacesList.list.elementAt(_selected-1).coordinate.split(';');
                  launch("https://www.google.com/maps?q="+tCoordinate.elementAt(0)+","+tCoordinate.elementAt(1)); 
                }
                },
            )
          ],
        )
      ),
    );
  }

  List<Widget> generate(){
 
    List<Widget> returnList = new  List<Widget>();

    returnList.add(
      new RadioListTile(
        value: 0,
        groupValue: _selected,
        onChanged: (int index){loadIMG(index);},
        title: new Text("Łowisko"),
      )
    );


    for(int i=0; i < Warehouse.selectedFishery.parkingPlacesList.list.length; i++)
    {
      returnList.add(new RadioListTile(
        value: i+1,
        groupValue: _selected,
        onChanged: (int index){loadIMG(index);},
        title: new Text(Warehouse.selectedFishery.parkingPlacesList.list.elementAt(i).name),
      ));
      
    }

    return returnList;
  }

  void loadIMG(int index)
  {
    if(index == 0)
    {
      _img = Warehouse.selectedFishery.img ;
      _selected = 0;
    }else{
      _img = Warehouse.selectedFishery.parkingPlacesList.list.elementAt(index-1).img ;
      _selected = index;
    }

    setState(() {});

  }
}
