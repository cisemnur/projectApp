// ignore_for_file: unnecessary_set_literal

import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:projectapp/detayEkrani.dart';
import 'package:projectapp/profilEkrani.dart';
import 'package:projectapp/resimDetayEkrani.dart';
import 'package:projectapp/sepetEkrani.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class apiPage extends StatefulWidget {
  @override
  State<apiPage> createState() => _apiPageState();
}

class _apiPageState extends State<apiPage> {
  List<dynamic> _jsonData = [];
  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.npoint.io/6a9e32003c448e9c69d2')); //Restoran bilgilerini kayıt ettiğimiz JSON verilerimizi http api yardımıyla burada çekiyoruz

    if (response.statusCode == 200) {
      setState(() {
        _jsonData = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future _signOut() async {
    await FirebaseAuth.instance.signOut(); //Kullanıcı çıkışı yapar
  }

///////////////////////
  var uuid = Uuid();
  Future<void> sepetEkle(String urunIDParameter, String urunAd,
      String urunFiyat, String urunURL) async {
      String randomID = uuid.v4();
      FirebaseFirestore.instance.collection("sepet").doc(randomID).set({
        "sepetID": randomID,
        "urunAd": urunAd,
        "urunAdet": "1",
        "urunFiyat": urunFiyat,
        "urunID": urunIDParameter,
        "urunURL": urunURL,
        "userID": FirebaseAuth.instance.currentUser!.uid,
        "satinAlindiMi": "Hayir"
      }).whenComplete(() => {
            Fluttertoast.showToast(
                msg: "Ürün sepete eklenmiştir!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 65, 123, 98),
                textColor: Colors.white,
                fontSize: 16.0)
          });
  }

  ///////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          child: Icon(Icons.shopping_basket),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => sepetEkran()));
          },
          heroTag: null,
        ),
        SizedBox(
          width: 10,
        ),
        FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 121, 208, 242),
          child: Icon(Icons.person_4),
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => profilEkran()))
          },
          heroTag: null,
        )
      ]),
      appBar: AppBar(
        //255,37, 150, 190
        backgroundColor: Color.fromARGB(255, 62, 175, 195),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Restourant Yemek Listesi",
              style: GoogleFonts.cinzel(
                  fontSize: 25, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: _jsonData.length,
          itemBuilder: (context, index) {
            return FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 241, 236, 222),
                  ),
                  margin:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  child: Column(children: [
                    BounceInLeft(
                        from: 100,
                        // duration: Duration(milliseconds: 1500),
                        child: Text(_jsonData[index]["eatName"],
                            style: GoogleFonts.pacifico(
                                color: Color.fromARGB(255, 246, 0, 0),
                                fontSize: 19))),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  //Sayfa yönlendirme(Resme tıkladıgında büyük boyutlu görünmesi için diğer sayfaya resmin url sini parametre olarak gönderir )
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => resimDetayEkran(
                                          _jsonData[index]["eatIMG"])));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 150,
                              height: 120,
                              child: Image.network(
                                _jsonData[index][
                                    "eatIMG"], //Bu widget, resmin yüklenmesini ve görünmesini saglar.
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //bura
                            Container(
                                //Http apiden gelen her verinin açıklama kısmı
                                width: 160,
                                height: 90,
                                child: Text(_jsonData[index]["explane"],
                                    style: GoogleFonts.asap(
                                        color: Color.fromARGB(255, 40, 55, 68),
                                        fontSize: 17))),
                            FadeInRight(
                                duration: Duration(milliseconds: 1500),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        detayEkran(
                                                            _jsonData[index]
                                                                ["eatIMG"],
                                                            _jsonData[index]
                                                                ["eatName"],
                                                            _jsonData[index]
                                                                ["explane"])));
                                          },
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Icon(
                                              Icons.info,
                                              size: 25,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            sepetEkle(
                                                _jsonData[index]["eatID"],
                                                _jsonData[index]["eatName"],
                                                _jsonData[index]["eatPrice"],
                                                _jsonData[index]["eatIMG"]);
                                          },
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Icon(
                                              Icons.shopping_cart,
                                              size: 25,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        )
                      ],
                    )
                  ]),
                ));
          },
        ),
      ),
    );
  }
}
