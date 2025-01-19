// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_set_literal, unused_import, unused_local_variable, prefer_const_constructors, body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectapp/api.dart';
import 'package:projectapp/main.dart';
import 'package:validators/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class kayitEkran extends StatefulWidget {
  const kayitEkran({Key? key}) : super(key: key);

  @override
  State<kayitEkran> createState() => kayitEkranState();
}

class kayitEkranState extends State<kayitEkran> {
  TextEditingController _txtadSoyadController = TextEditingController();
  TextEditingController _txtemailController = TextEditingController();
  TextEditingController _txtsifreController = TextEditingController();
  TextEditingController _txtsifretekrarController = TextEditingController();
  TextEditingController _txtuserPhoneController = TextEditingController();

  @override
  void dispose() {
    _txtadSoyadController.clear();
    _txtemailController.clear();
    _txtsifreController.clear();
    _txtsifretekrarController.clear();
    _txtuserPhoneController.clear();
    super.dispose();
  }

  bool isEmailCorrect = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

/////////////////////////////////////////////////////////////////////
  void ekleKullanici(String adSoyad, String email, String telNumber) async {
    DocumentReference userRefdoc =
        userRef.doc(FirebaseAuth.instance.currentUser!.uid);
    await userRefdoc.set({
      'kullaniciAdSoyad': adSoyad,
      'kullaniciMail': email,
      'kullaniciTelefon': telNumber,
      'kullaniciID': FirebaseAuth.instance.currentUser!.uid
    }).whenComplete(() => {
    print("dsfsdfsdfsdf---------"),
         // FirebaseAuth.instance.signOut(),
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp()))
          /* Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homeScreen()))*/
        });
  }

//Firebase'e kullanıcı kaydını oluşturma (authentication) methodu, userCreate
  Future<void> userCreate(
      String email, String password, String telNumber) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => {
                ekleKullanici(_txtadSoyadController.text, email,
                    _txtuserPhoneController.text)
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //Eğer hatalı giriş yapılırsa hatalara göre aşağıdaki bildirimleri göstermektedir.
        print('weak-password');
        Fluttertoast.showToast(
            msg: "Zayıf şifre!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'email-already-in-use') {
        print('email-already-in-use');
        Fluttertoast.showToast(
            msg: "Bu mail zaten kullanılıyor!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            // color: Colors.red.withOpacity(0.1),
            image: DecorationImage(
                image: NetworkImage(
                    // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShp2T_UoR8vXNZXfMhtxXPFvmDWmkUbVv3A40TYjcunag0pHFS_NMblOClDVvKLox4Atw&usqp=CAU',
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx7IBkCtYd6ulSfLfDL-aSF3rv6UfmWYxbSE823q36sPiQNVFFLatTFdGeUSnmJ4tUzlo&usqp=CAU'),
                fit: BoxFit.cover,
                opacity: 0.3)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 7),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Lottie.network(
                      // 'https://assets6.lottiefiles.com/private_files/lf30_ulp9xiqw.json', //shakeing lock
                      'https://assets6.lottiefiles.com/packages/lf20_k9wsvzgd.json',
                      animate: true,
                      height: 120,
                      width: 600),
                  Text(
                    'Kayıt ol',
                    style: GoogleFonts.indieFlower(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Text(
                    'Kayıt olmak için lütfen bilgilerinizi giriniz!',
                    style: GoogleFonts.indieFlower(
                      textStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w300,
                          // height: 1.5,
                          fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 460,
                    //_formKey!.currentState!.validate() ? 200 : 600,
                    // height: isEmailCorrect ? 260 : 182,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 0, top: 20),
                          child: TextFormField(
                            controller: _txtadSoyadController,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.purple,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Ad Soyad",
                              hintText: 'Lütfen isminizi yazın',
                              labelStyle: TextStyle(color: Colors.purple),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 0, top: 20),
                          child: TextFormField(
                            controller: _txtuserPhoneController,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.purple,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Telefon",
                              hintText: 'Lütfen numaranızı yazın',
                              labelStyle: TextStyle(color: Colors.purple),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 20),
                          child: TextFormField(
                            controller: _txtemailController,
                            onChanged: (val) {
                              setState(() {
                                isEmailCorrect = isEmail(val);
                              });
                            },
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.purple,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Email",
                              hintText: 'email@domain.com',
                              labelStyle: TextStyle(color: Colors.purple),
                              // suffixIcon: IconButton(
                              //     onPressed: () {},
                              //     icon: Icon(Icons.close,
                              //         color: Colors.purple))
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _txtsifreController,
                              obscuringCharacter: '*',
                              obscureText: true,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.purple,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Şifre",
                                hintText: '*********',
                                labelStyle: TextStyle(color: Colors.purple),
                              ),
                              validator: (value) {
                                if (value!.isEmpty && value.length < 6) {
                                  return 'Enter a valid password (at least 6 characters)';
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Form(
                            key: _formKey2,
                            child: TextFormField(
                              controller: _txtsifretekrarController,
                              obscuringCharacter: '*',
                              obscureText: true,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.purple,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Şifre tekrar",
                                hintText: '*********',
                                labelStyle: TextStyle(color: Colors.purple),
                              ),
                              validator: (value) {
                                if (value!.isEmpty && value.length < 6) {
                                  return 'Enter a valid password (at least 6 characters)';
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: Colors.purple,
                              /*  padding: EdgeInsets.symmetric(
                                        horizontal: 131, vertical: 20)*/
                              padding: EdgeInsets.only(
                                  left: 120, right: 120, top: 10, bottom: 10),
                            ),
                            onPressed: () {
                              //Eğer text kutuları boş geçilmişse hata verecek geçmemişse işleme devam edecek.
                              if (_txtadSoyadController.text == "" ||
                                  _txtemailController.text == "" ||
                                  _txtsifreController.text == "" ||
                                  _txtsifretekrarController.text == "") {
                                Fluttertoast.showToast(
                                    msg: "Please do not leave any spaces!",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                if (_txtsifreController.text.length < 6) {
                                  //Eğer şifre en az 6 karakterse hata verecek değilse işleme devam edecek.
                                  Fluttertoast.showToast(
                                      msg:
                                          "Password must be at least 6 characters!",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  //Eğer girilen şifreler aynı ise işleme devam edecek değilse hata verecek.
                                  if (_txtsifreController.text ==
                                      _txtsifretekrarController.text) {
                                    userCreate(
                                        _txtemailController.text,
                                        _txtsifreController.text,
                                        _txtuserPhoneController.text);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Passwords are not the same!",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                }
                              }
                            },
                            child: Text(
                              'Kayıt ol',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            )),
                      ],
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Zaten bir hesabım var.',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Giriş yap',
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
