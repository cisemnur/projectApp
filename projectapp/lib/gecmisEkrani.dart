import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class gecmisEkran extends StatefulWidget {
  @override
  State<gecmisEkran> createState() => gecmisEkranState();
}

class gecmisEkranState extends State<gecmisEkran> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(    appBar: AppBar(backgroundColor: Color.fromARGB(255, 80, 230, 230),
          title: Text('Geçmiş Siparişler',
              style: GoogleFonts.montserratAlternates(
                  fontSize: 25, color: Color.fromARGB(255, 0, 0, 0))),
        ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('sepet')
              .where('userID',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
              .where("satinAlindiMi", isEqualTo: "Evet")
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
