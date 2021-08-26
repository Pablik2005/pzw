import 'package:flutter/material.dart';

import 'package:pzw/warehouse.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationViewStateView createState() => new _RegistrationViewStateView();
}

class _RegistrationViewStateView extends State<RegistrationView> {

  bool _emailON = false;
  bool _passwordON = false;

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _password2 = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _surname = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _postOffice = new TextEditingController();
  TextEditingController _mobilePhone = new TextEditingController();
  TextEditingController _landlinePhone = new TextEditingController();
  TextEditingController _fishingCardNumber = new TextEditingController();

  @override
  void initState(){

    _email.addListener((){
      if(_email.text.isNotEmpty)
        _emailON = true;
      else
        _emailON = false;
    });

    _password.addListener((){
      if(_password.text == _password2.text && _password.text.isNotEmpty) 
        _passwordON = true;
      else
        _passwordON = false;
    });

    _password2.addListener((){
      if(_password.text == _password2.text && _password.text.isNotEmpty) 
        _passwordON = true;
      else
        _passwordON = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sendButtonPushed;
    if(_emailON && _passwordON)
      sendButtonPushed = () async {

        Warehouse.addUser(
          _email.text,
          _password.text,
          _name.text,
          _surname.text,
          _address.text,
          _postOffice.text,
          _mobilePhone.text,
          _landlinePhone.text,
          _fishingCardNumber.text)
        .then((id){
          Warehouse.isLogin = true;
          Warehouse.user.id = id;
          Warehouse.user.email = _email.text;
          Warehouse.user.password = _password.text;

          Navigator.of(context).pushNamedAndRemoveUntil("FisheryListView", (Route<dynamic> route) => false);

        });
          
          
          
      };

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        actions: <Widget>[],
      ),
      body: new Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: ListView(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _email,
                decoration: new InputDecoration(labelText: 'Email :')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _password,
                decoration: new InputDecoration(labelText: 'Hasło :'),
                obscureText: true,
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _password2,
                decoration: new InputDecoration(labelText: 'Powtórz hasło :'),
                obscureText: true,
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _name,
                  decoration: new InputDecoration(labelText: 'Imię :')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _surname,
                  decoration: new InputDecoration(labelText: 'Nazwisko :')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _address,
                  decoration: new InputDecoration(labelText: 'Adres :')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _postOffice,
                  decoration: new InputDecoration(labelText: 'Poczta :')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _landlinePhone,
                  decoration:
                      new InputDecoration(labelText: 'Tel. Stacjonarny :')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _mobilePhone,
                  decoration:
                      new InputDecoration(labelText: 'Tel. Komórkowy :')),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: new TextFormField(
                controller: _fishingCardNumber,
                  decoration: new InputDecoration(
                      labelText: 'Nr. Karty Wędkarskiej :')),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 50.0),
              child: new RaisedButton(
                child: new Text("Wyślij"),
                onPressed: sendButtonPushed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
