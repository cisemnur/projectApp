import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:projectapp/gecmisEkrani.dart';

class sepetEkran extends StatefulWidget {
  @override
  State<sepetEkran> createState() => sepetEkranState();
}

class sepetEkranState extends State<sepetEkran> {
  double toplamFiyat = 0;
  int counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toplamFiyat = 0;
    counter = 0;
    sepetIDList = [];
  }

  Future<void> updateSatinAlindiMiField() async {
    try {
      print("sdsfdd");
      // Şu anki giriş yapan kullanıcının UID'sini al
      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception('Kullanıcı giriş yapmamış.');
      }

      // Firestore referansını al
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Sepet koleksiyonunda kullanıcıya ait olan belgeleri al
      final QuerySnapshot snapshot = await firestore
          .collection('sepet')
          .where('userID', isEqualTo: userId)
          .get();

      // Her belge için satinAlindiMi alanını "Evet" olarak güncelle
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.update({'satinAlindiMi': 'Evet'});
      }
      Fluttertoast.showToast(
          msg: "Sipariş işlemi başarılı. Afiyet olsun!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 42, 72, 101),
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      print('Güncelleme başarılı.');
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  List<String> sepetIDList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 80, 230, 230),
        title: Text('Sepetim',
            style: GoogleFonts.montserratAlternates(
                fontSize: 25, color: Color.fromARGB(255, 0, 0, 0))),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 255, 185, 7),
            child: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => gecmisEkran()));
            },
            heroTag: null,
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: 150,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 7, 164, 255),
              child: Text("SATIN AL"),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "Sipariş gerçekleştiriliyor...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color.fromARGB(255, 42, 72, 101),
                    textColor: Colors.white,
                    fontSize: 16.0);
                updateSatinAlindiMiField();
              },
              heroTag: null,
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('sepet')
              .where('userID',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
              .where("satinAlindiMi", isEqualTo: "Hayir")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData == false) {
              return Text(" Sepetiniz boş durumdadır.");
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  toplamFiyat += double.parse(data['urunFiyat']) *
                      double.parse(data['urunAdet']);
                  sepetIDList.add(data['sepetID']);
                  counter++;
                  return Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          child: Image.network(
                            data['urunURL'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                textAlign: TextAlign.left,
                                data['urunAd'],
                                style: GoogleFonts.comfortaa(fontSize: 15),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(textAlign: TextAlign.left, "Adet: "),
                                  Text(data['urunAdet'],
                                      style:
                                          GoogleFonts.comfortaa(fontSize: 15))
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text("Fiyat: "),
                                  Text(data['urunFiyat'] + " TL",
                                      style:
                                          GoogleFonts.comfortaa(fontSize: 15))
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              counter == snapshot.data!.docs.length
                                  ? SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 26,
                                            width: 165,
                                            color: Colors.amber,
                                            child: Text("TOPLAM FİYAT: " +
                                                toplamFiyat.toString() +
                                                " TL"),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
