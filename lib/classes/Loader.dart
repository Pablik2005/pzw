import 'package:flutter/material.dart';

class Loader extends StatefulWidget{


  _LoaderStateView _loaderStateView = new _LoaderStateView();

  @override
  _LoaderStateView createState() => _loaderStateView;

  void  setHeigh(double fHeight)
  {
    _loaderStateView._height = fHeight;
  }
  void  start(){ _loaderStateView.start(); }
  void  finish(){ _loaderStateView.finish(); }
  void  redy(){ _loaderStateView.redy(); }



}

class _LoaderStateView extends State<Loader> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Animation<double>   _animation;
  Image               _image;
  double              _height=20.0;

  @override
  void initState(){

    _controller = new AnimationController( duration: new Duration(milliseconds: 1000), vsync: this );
    _animation = new CurvedAnimation(parent: _controller, curve: Curves.linear);
    _animation.addListener((){
      setState(() {});
    });

    start();

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Container(
      child: new Transform.rotate(
        angle: _controller.value  *  6.28, //Kąt w radianach
        child: _image,
      ),
    );
  }

  void redy(){
    _controller.stop();
    _image = new Image.asset(
      "assets/loading.png",
      height: _height,
    );
    setState(() {});
  }  

  void start(){
    _image = new Image.asset(
      "assets/loading.png",
      height: _height,
    );
     _controller.repeat();     
  }

  void finish(){ 
    _controller.stop();
    _controller.value = 0.0;
    _image = new Image.asset(
      "assets/loaded.png",
      height: _height,
    );
    setState(() {});
  }
}