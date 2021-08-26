import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:pzw/warehouse.dart';

class ImageView extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Podgląd"),
      ),
      body: new Container(
      child: new PhotoViewInline(
        imageProvider: Warehouse.selectedImage.image ,
        minScale: PhotoViewScaleBoundary.contained * 0.8,
        maxScale: 4.0,
      ),
    ),
    );  
  }
}