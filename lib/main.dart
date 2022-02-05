import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pagination_algorithm/controller_pagination.dart';
import 'package:pagination_algorithm/utama.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class ListPerusahaan {
  String id_angka;
  String bumn_name;
  int bod;
  int boc;
  int count;
  ListPerusahaan({
    this.id_angka,
    this.bumn_name,
    this.bod,
    this.boc,
    this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_angka': id_angka,
      'bumn_name': bumn_name,
      'bod': bod,
      'boc': boc,
      'count': count,
    };
  }

  factory ListPerusahaan.fromMap(Map<String, dynamic> map) {
    return ListPerusahaan(
      id_angka: map['id_angka'],
      bumn_name: map['bumn_name'],
      bod: map['bod'],
      boc: map['boc'],
      count: map['count'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ListPerusahaan.fromJson(String source) =>
      ListPerusahaan.fromMap(json.decode(source));
}

class BumnPerusahaan {
  bool success;
  int current_page;
  List<ListPerusahaan> data;
  int last_page;
  BumnPerusahaan({
    this.success,
    this.current_page,
    this.data,
    this.last_page,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'current_page': current_page,
      'data': data?.map((x) => x.toMap())?.toList(),
      'last_page': last_page,
    };
  }

  factory BumnPerusahaan.fromMap(Map<String, dynamic> map) {
    return BumnPerusahaan(
      success: map['success'],
      current_page: map['current_page'],
      data: List<ListPerusahaan>.from(
          map['data']?.map((x) => ListPerusahaan.fromMap(x))),
      last_page: map['last_page'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BumnPerusahaan.fromJson(String source) =>
      BumnPerusahaan.fromMap(json.decode(source));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Utama(),
    );
  }
}

List<ListPerusahaan> dataList = [];

class Home extends StatelessWidget {
  ScrollController _scrollController = new ScrollController();

  int page = 1;
  int maxPage = 1;

  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page < maxPage) {
          page++;
          var hasil = await fetchDataPageOther(page);
          if (hasil == 1)
            Get.put<PaginationController>(PaginationController())
                .updatePagination();
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: GetBuilder<PaginationController>(
        id: 'refreshPagination',
        init: PaginationController(),
        builder: (controller) {
          return FutureBuilder<BumnPerusahaan>(
            future: fetchData(page),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var hasil = snapshot.data;
                maxPage = hasil.last_page;
                dataList = hasil.data;
                return GetBuilder<PaginationController>(
                  init: PaginationController(),
                  id: 'paginationRefresh',
                  builder: (controller) {
                    // Get.defaultDialog(title: "Waiting For...");
                    return ListView(
                      controller: _scrollController,
                      children: [
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: () {},
                          child: Text("Refresh Button"),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child:
                                  Text("$index ${dataList[index].bumn_name}"),
                            );
                          },
                        ),
                        (maxPage == page)
                            ? Container()
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ],
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}

Future<BumnPerusahaan> fetchData(int page) async {
  final response =
      await http.get("https://eid.bumn.go.id/api/hc/bumn/anak?page=$page");

  if (response.statusCode == 201 || response.statusCode == 200) {
    var dataGet = json.decode(response.body);
    var dataHasil = (dataGet as Map<String, dynamic>);
    return BumnPerusahaan.fromMap(dataHasil);
  } else {
    Map<String, dynamic> dataHandling = {
      "success": true,
      "current_page": 1,
      "last_page": 1,
      "data": [],
    };
    return BumnPerusahaan.fromMap(dataHandling);
  }
}

Future<int> fetchDataPageOther(int page) async {
  final response =
      await http.get("https://eid.bumn.go.id/api/hc/bumn/anak?page=$page");

  print(page);

  if (response.statusCode == 201 || response.statusCode == 200) {
    var dataGet = json.decode(response.body);
    var dataHasil = (dataGet as Map<String, dynamic>)['data'];

    for (int i = 0; i < dataHasil.length; i++) {
      dataList.add(new ListPerusahaan.fromMap(dataHasil[i]));
    }

    return 1;
  } else {
    return 2;
  }
}
