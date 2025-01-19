import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class detayEkran extends StatefulWidget {
  final String eatImageURL;
  final String eatName;
  final String eatExplane;
  detayEkran(this.eatImageURL, this.eatName, this.eatExplane);
  @override
 detayEkranState createState() =>
      detayEkranState(eatImageURL, eatName, eatExplane);
}

class detayEkranState extends State<detayEkran> {
  final String eatImageURL;
  final String eatName;
  final String eatExplane;
  detayEkranState(this.eatImageURL, this.eatName, this.eatExplane);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FadeInDown(
                    duration: Duration(milliseconds: 1000),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(eatImageURL),
                              fit: BoxFit.cover)),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                              Colors.black.withOpacity(.8),
                              Colors.black.withOpacity(.2),
                            ])),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FadeInUp(
                                        duration: Duration(milliseconds: 1500),
                                        child: Text(
                                          eatName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FadeInUp(
                      duration: Duration(milliseconds: 1500),
                      child: Text(
                        eatExplane,
                        style: GoogleFonts.playfairDisplay(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
