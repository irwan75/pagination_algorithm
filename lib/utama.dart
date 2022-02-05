import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_algorithm/main.dart';
import 'package:pagination_algorithm/second_page.dart';
import 'package:pagination_algorithm/storage_preferences.dart';

class Utama extends StatelessWidget {
  DateTime now = new DateTime.now();

  SessionLogin dateTimeSet = new SessionLogin(tgl: 03, bln: 04, thn: 2021);
  var selisih;

  @override
  Widget build(BuildContext context) {
    SessionLogin dateTimeSave =
        new SessionLogin.fromMap(jsonDecode(StoragePreferences.getTimeLogin()));
    return Scaffold(
      appBar: AppBar(
        title: Text("Utama"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(
                  "Time Now : ${dateTimeSave.tgl} -- ${dateTimeSave.bln} -- ${dateTimeSave.thn}"),
              MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  StoragePreferences.setTimeLogin(new SessionLogin(
                      bln: now.month, tgl: now.day, thn: now.year));
                  // print("${now.day} -- ${now.month} -- ${now.year}");
                  // final datestart = DateTime(2021, 02, 29);
                  // final dateend = DateTime(2021, 03, 03);
                  // selisih = dateend.difference(datestart).inDays;

                  // print(selisih.toString());
                  // var map = new Map<String, String>();
                  // map["sesscode"] = "Mantapp";
                  // map["regno"] = "Tidak Mantap";

                  // Get.to(Home());
                  var hasil = await methodSession(01, 04,
                      2021); //date Save to Storage References after login
                  if (hasil == 1) {
                    print("Session LogOut");
                  } else {
                    print("Session Not LogOut");
                  }
                },
                child: Text(
                  "Next Page",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> methodSession(int tgl, int bln, int thn) async {
    final datestart = DateTime(thn, bln, tgl);
    final dateend = DateTime(dateTimeSet.thn, dateTimeSet.bln, dateTimeSet.tgl);
    print(dateend.difference(datestart).inDays);

    if (dateTimeSet.tgl < tgl + 3) {
      if ((dateend.difference(datestart).inDays) < 4) {
        print("2");
        return 0;
      } else if (dateTimeSet.bln > bln) {
        print("3");
        return 1;
      } else if (dateTimeSet.thn > thn) {
        print("4");
        return 1;
      } else {
        print("5");
        return 0;
      }
    } else {
      print("1");
      return 1;
    }
  }
}

// 29 03 2021
// 01 04 2021
