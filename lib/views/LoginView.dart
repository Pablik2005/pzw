import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

import 'package:pzw/warehouse.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewStateView createState() => new _LoginViewStateView();
}

class _LoginViewStateView extends State<LoginView> {
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _keepPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: new Container(
        decoration: new BoxDecoration(color: Colors.blue),
        child: new ListView(
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Image(
                      image: new AssetImage("assets/logo.ico"),
                      width: 150.0,
                      height: 150.0,
                    ),
                  ],
                )),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextField(
                  controller: _email,
                  decoration: new InputDecoration(labelText: 'Email :')),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 0.0),
              child: new TextField(
                controller: _password,
                decoration: new InputDecoration(labelText: 'Password :'),
                obscureText: true,
              ),
            ),
            new Container(
                margin: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 0.0),
                child: new CheckboxListTile(
                  value: _keepPassword,
                  title: new Text("Zapamiętaj"),
                  onChanged: (val) {
                    keepPasswordPressed(val);
                  },
                )),
            new Container(
              margin: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 0.0),
              child: new RaisedButton(
                child: new Text("Zaloguj"),
                onPressed: () {
                  loginPressed();
                },
              ),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 50.0),
              child: new RaisedButton(
                child: new Text("Rejstracja"),
                onPressed: () {
                  Navigator.of(context).pushNamed('RegistrationView');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void keepPasswordPressed(bool fVal) {
    _keepPassword = fVal;
    setState(() {});
  }

  void loginPressed() async {
    List<String> respond =
        await Warehouse.tryLogin(_email.text, _password.text);
    if (respond.elementAt(0) == "id") {
      Warehouse.isLogin = true;
      Warehouse.user.id = respond.elementAt(1);
      Warehouse.user.email = _email.text;
      Warehouse.user.password = _password.text;

      if(_keepPassword)
        saveAccount();
      else
      {
        Directory tDirectory = await getApplicationDocumentsDirectory();
        File tFile = new File(tDirectory.path + '/user.data');
        if(tFile.existsSync())
          tFile.deleteSync();
      }

      Navigator.of(context).pushNamed('FisheryListView');
    } else
      _password.text = "";
  }

  Future<bool> saveAccount() async {
    Directory tDirectory = await getApplicationDocumentsDirectory();
    File tFile = new File(tDirectory.path + '/user.data');
    tFile.writeAsStringSync(Warehouse.user.id+";"+Warehouse.user.email+";"+Warehouse.user.password);
    return true;
  }
}
