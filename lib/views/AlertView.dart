import 'package:flutter/material.dart';

import 'package:pzw/warehouse.dart';

class AlertView extends StatefulWidget {
  @override
  _AlertViewStateView createState() => new _AlertViewStateView();
}

class _AlertViewStateView extends State<AlertView> {


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Warehouse.selectedAlert.type),
      ),
      body: new Container(
        margin: EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 10.0),
        child: new Column(
          children: <Widget>[
            Warehouse.selectedAlert.img,
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Text("Data : ${Warehouse.selectedAlert.startDate.toString().substring(0,16)}"),
                new Text("Czas : ${Warehouse.selectedAlert.time}"),
              ], 
            ),
            new TextField(
              enabled: false,
              maxLines: 15,
              controller: new TextEditingController(text:  Warehouse.selectedAlert.content),
            )
          ],
        )
      ),
    );
  }



}
