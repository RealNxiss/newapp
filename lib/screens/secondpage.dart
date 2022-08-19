// ignore_for_file:  prefer_const_constructors_in_immutables, avoid_print, depend_on_referenced_packages

// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:newapp/screens/statspage.dart';
import 'package:newapp/themecode/themecode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class SecondRoute extends StatefulWidget {
  SecondRoute({Key? key}) : super(key: key);

  @override
  Valid createState() => Valid();

  void onSubmit(String amount) {}
}

class Valid extends State<SecondRoute> {
  // declare a variable to keep track of the input text
  String amount = ' ';
  final TextEditingController _controllerField = TextEditingController();
  int _groceries = 0;
  int _essentials = 0;
  int _others = 0;

  getValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? money = pref.getInt('money value');
    return money;
  }

  getEssValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? money = pref.getInt('Ess');
    return money;
  }

  getOthValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? money = pref.getInt('Oth');
    return money;
  }

  setGroceries() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('money value', _groceries);
  }

  setEssentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('Ess', _essentials);
  }

  setOthers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('Oth', _others);
  }

  checkGrocvalue() async {
    int groc = await getValue() ?? 0;
    setState(() {
      _groceries = groc;
    });
  }

  checkEssvalue() async {
    int ess = await getEssValue() ?? 0;
    setState(() {
      _essentials = ess;
    });
  }

  checkOthvalue() async {
    int oth = await getOthValue() ?? 0;
    setState(() {
      _others = oth;
    });
  }

  @override
  void initState() {
    super.initState();
    checkGrocvalue();
    checkEssvalue();
    checkOthvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: txtBgclr,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: razerColor,
        title: const Text(
          'Money Spent',
          style: TextStyle(
              color: txtBgclr, fontFamily: 'DidactGothic', fontSize: 30),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Enter Your Spent Amount',
              style: TextStyle(
                  color: txtclr, fontFamily: 'DidactGothic', fontSize: 26),
            ),
            const SizedBox(
              height: 80,
            ),
            ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: 200, height: 100),
              child: TextField(
                onChanged: (val) => setState(() {
                  amount = val;
                }),
                controller: _controllerField,
                keyboardType: TextInputType.number,
                cursorColor: txtclr,
                style: const TextStyle(color: txtclr, fontSize: 30),
                decoration: const InputDecoration(
                    hintStyle: (TextStyle(
                        color: txtclr,
                        fontFamily: 'DidactGotgic',
                        fontSize: 20)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: txtclr)),
                    hintText: 'Amount'),
              ),
             ),
            ElevatedButton(
                style: style1,
                onPressed: () {
                  final groc = _controllerField.text;

                  userSetup(money: groc);
                  _controllerField.clear();
                  
                },
                child: const Text('Groceries')),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: style1,
                onPressed: () {
                  _essentials = _essentials + int.parse(amount);
                  print(_essentials);
                  setEssentials();
                  _controllerField.clear();
                },
                child: const Text('Essentials')),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: style1,
                onPressed: () {
                  _others = _others + int.parse(amount);
                  print(_others);
                  setOthers();
                  _controllerField.clear();
                },
                child: const Text('Others')),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: style1,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StatsPage(
                          groceries: _groceries.toString(),
                          Essentials: _essentials.toString(),
                          others: _others.toString())));
                },
                child: const Text('View Stats')),
          ],
        ),
      ),
    );
  }

  Future userSetup({required String money}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    int mnd = int.parse(money);
    final docUser = FirebaseFirestore.instance.collection('Groceries').doc(uid);
    final json = {'Groceries': FieldValue.increment(mnd)};

    await docUser.set(json, SetOptions(merge: true));
  }
}
