import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:pzw/warehouse.dart';

class AddTrophyView extends StatefulWidget {
  @override
  _AddTrophyViewStateView createState() => new _AddTrophyViewStateView();
}

class _AddTrophyViewStateView extends State<AddTrophyView> {
  File _imageFile;
  bool _contentON = false;
  bool _imgON = false;
  bool _lockButton = false;
  final TextEditingController _imgTag = new TextEditingController(text: "Brak");
  final TextEditingController _content = new TextEditingController();

  @override
  void initState(){

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
  Widget build(BuildContext context){
    var _buttonSendFunction;
    if(_contentON && _imgON && !_lockButton)
      _buttonSendFunction = () async {
        setState(() {
          _lockButton = true;          
        });

        var tBase64="";
        if(_imgTag.text != "Brak")
          tBase64 = base64.encode( _imageFile.readAsBytesSync() );
        
        Warehouse.addTrophy(
          Warehouse.selectedFishery.id, 
          Warehouse.user.id,
          tBase64,
          _content.text)
        .then((val){

          Warehouse.getTrophyListFromFishery( Warehouse.selectedFishery.id)
          .then((val){
            Navigator.pop(context,true);
          });
          
        });
      };


    return Scaffold(
      appBar: AppBar(
        title: Text(Warehouse.selectedFishery.name),
      ),
      body: new ListView(
        children: <Widget>[

          //Zdjęcie
          new Container(
            margin: new EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Zdjęcie :"),
                new Text('<' + _imgTag.text + '>'),
              ],
            ),
          ),

          // Zawartość
          new Container(
              margin: new EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
              child: TextField(
                  controller: _content,
                  maxLines: 10,
                  decoration: new InputDecoration(
                    hintText: 'Opis',
                  ))),

          // Send Button
          new Container(
            margin: new EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
            child: new RaisedButton(
              onPressed: _buttonSendFunction,
              child: new Text("Wyślij"),
              elevation: 4.0,
            ),
          ),
        ],
      ),

      floatingActionButton: new FloatingActionButton(
        tooltip: 'Pick Image',
        onPressed: getImage,
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  getImage() async {

    _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    _imgON = true;
    if (_imageFile != null)
      setState(() {
        _imgTag.text = basename("Dodano");
      });
  }
}
