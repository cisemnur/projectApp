// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectapp/girisEkrani.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

///////////////////
class FadeRouteBuilderr<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilderr({required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}

class profilEkran extends StatefulWidget {
  @override
  State<profilEkran> createState() => profilEkranstate();
}

class profilEkranstate extends State<profilEkran> {
  String getUserName = "";
  String getUserTel = "";
  String getUserEmail = "";

  Future<void> getguserValues() async {
    final CollectionReference myCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await myCollection
        .where("kullaniciID",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
        .get();
    for (var doc in querySnapshot.docs) {
      setState(() {
        getUserName = doc.get("kullaniciAdSoyad");
        getUserTel = doc.get("kullaniciTelefon");
        getUserEmail = doc.get("kullaniciMail");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getguserValues();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 80, 230, 230),
          title: Text('Profil',
              style: GoogleFonts.montserratAlternates(
                  fontSize: 25, color: Color.fromARGB(255, 0, 0, 0))),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            height: MediaQuery.of(context).size.height * .97,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(5),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromARGB(255, 76, 132, 175).withAlpha(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Ad Soyad: ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, color: Colors.black),
                      ),
                      Text(
                        getUserName,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 7,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(5),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromARGB(255, 76, 132, 175).withAlpha(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Telefon: ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, color: Colors.black),
                      ),
                      Text(
                        getUserTel,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 7,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(5),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromARGB(255, 76, 132, 175).withAlpha(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Email: ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, color: Colors.black),
                      ),
                      Text(
                        getUserEmail,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 7,
              ),
              IconsButton(
                onPressed: () {
                  /////////////////
                  Alert(
                    onWillPopActive: true,
                    closeIcon: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                    context: context,
                    title: "ÇIKIŞ YAP",
                    content: Container(
                        padding: EdgeInsets.only(top: 17),
                        child: Text("Çıkış yapmak istiyor musunuz?")),
                    buttons: [
                      DialogButton(
                        child: Text(
                          "İptal",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        color: Color.fromARGB(255, 151, 79, 8),
                      ),
                      DialogButton(
                        child: Text(
                          "ÇIKIŞ YAP",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          FirebaseAuth.instance
                              .signOut()
                              .then((value) => Navigator.of(context).pop())
                              .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => girisEkran())));
                        },
                        color: Color.fromARGB(255, 8, 130, 151),
                      )
                    ],
                  ).show();
                  //////////////////////
                },
                text: 'ÇIKIŞ YAP',
                iconData: Icons.logout_sharp,
                color: Colors.green,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              )
            ]))));
  }
}
