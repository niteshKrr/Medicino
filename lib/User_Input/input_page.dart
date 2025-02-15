import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicino/Report/output_page.dart';
import 'package:medicino/User_Input/slider.dart';
import 'package:medicino/User_Input/symptoms.dart';
import 'package:medicino/User_Input/user_sex.dart';
import 'loading_screen.dart';
import 'package:medicino/User_Input/fetching_data.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicino/models/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<InputPage> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const UserSex(),
          const Spacer(),
          Column(
            children: const [
              CustomSlider('Age (in years)', 19, 1, 100),
              CustomSlider('Weight (in kg)', 64, 25, 130),
              CustomSlider('Height (in cm)', 170, 120, 220),
            ],
          ),
          const Spacer(
            flex: 1,
          ),
          Row(
            children: const [
              Expanded(
                flex: 3,
                child: Divider(
                  color: Colors.black,
                  thickness: 4.0,
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Text('Symptoms'),
              Spacer(),
              Expanded(
                flex: 3,
                child: Divider(
                  color: Colors.black,
                  thickness: 4.0,
                ),
              ),
            ],
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: symp.length,
              itemBuilder: (BuildContext context, int idx) {
                return Symptom(symp[idx], idx);
              },
            ),
          ),
          GestureDetector(
            onTap: () async {
              var connectivityResult =
                  await (Connectivity().checkConnectivity());
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi) {
                Fluttertoast.showToast(
                    msg: "Please check your internet connection.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Loading()),
                );
                for (int i = 0; i < symp.length; i++) {
                  if (symp[i][0] == 't') {
                    var content = await fetchMedicine(i + 1);
                    if (content.statusCode == 200) {
                      final valo = jsonDecode(content.body);
                      dis.add(valo['disease']);
                      med.add(valo['medicine']);
                      img.add(valo['images']);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Sorry, an unexpected error occured.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }
                }
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const output_page(),
                  ),
                );
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.0),
                      topRight: Radius.circular(14.0))),
              height: 47.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'NEXT',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Symptom extends StatefulWidget {
  String txt;
  final int idx;
  Symptom(this.txt, this.idx, {Key? key}) : super(key: key);

  @override
  _SymptomState createState() => _SymptomState();
}

class _SymptomState extends State<Symptom> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(widget.txt.substring(1)),
        value: _value,
        onChanged: (value) {
          setState(() {
            _value = value!;
            widget.txt =
                (widget.txt[0] == 'f' ? 't' : 'f') + widget.txt.substring(1);
            symp[widget.idx] = widget.txt;
          });
        });
  }
}
