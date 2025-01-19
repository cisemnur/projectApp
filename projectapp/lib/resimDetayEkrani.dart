// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class resimDetayEkran extends StatefulWidget {
  String imageURL = "";
  resimDetayEkran(this.imageURL);

  @override
  State<resimDetayEkran> createState() => resimDetayEkranState(imageURL);
}

class resimDetayEkranState extends State<resimDetayEkran> {
  String imageURL = "";
  resimDetayEkranState(this.imageURL);

  @override
  void initState() {
    //Buraya ilk yüklendiği anda kodlar yazılır.
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.network(
            imageURL,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;//Resim büyük ekranda görünür. 
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          )),
    );
  }
}
