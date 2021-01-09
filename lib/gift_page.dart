import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GiftPage extends StatefulWidget {
  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  List<GiftModel> gifts = [];
  String dir;

  Future<void> apiCall() async {
    dir = (await getApplicationDocumentsDirectory()).path;
    var response = await http.get(
        'https://staging.aladdinshop.com.my/api/v1/entertainment/gift?api_key=22fd041a840f42a617793734f5f438e1',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    var data = jsonDecode(response.body);

    print(data.toString());

    for (int i = 0; i < data['data'].length; i++) {
      setState(() {
        gifts.add(GiftModel.fromJson(data['data'][i]));
      });
    }
  }

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'if it\'s downloading scroll up and down xia\nnext time start app no need wait le trust me hahaha',
          style: TextStyle(fontSize: 12),
        ),
      ),
      body: GridView.builder(
          cacheExtent: MediaQuery.of(context).size.height,
          itemCount: gifts.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3),
          itemBuilder: (BuildContext context, int index) {
            File file =
                File('$dir/gifts/${gifts[index].image.split('/').last}');
            return FutureBuilder(
                future: file.exists(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return Container(child: Image.file(file));
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Downloading asset'),
                          Container(child: CircularProgressIndicator()),
                        ],
                      );
                    }
                  } else {
                    return Container(child: CircularProgressIndicator());
                  }
                });
          }),
    );
  }
}

class GiftModel {
  int id;
  String name;
  int diamond;
  String image;

  GiftModel({this.id, this.name, this.diamond, this.image});

  factory GiftModel.fromJson(Map json) {
    return GiftModel(
        id: json['id'],
        name: json['name'],
        diamond: json['diamond'],
        image: json['image']);
  }
}
