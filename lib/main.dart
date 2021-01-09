import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bg_download_test/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> apiCall() async {
    var response = await http.get(
        'https://staging.aladdinshop.com.my/api/v1/entertainment/gift?api_key=22fd041a840f42a617793734f5f438e1',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    var data = jsonDecode(response.body);

    print(data.toString());

    for (int i = 0; i < data['data'].length; i++) {
      await _downloadFile(data['data'][i]['image'].toString(),
              (data['data'][i]['image'] as String).split('/').last)
          .then((value) {
        print('yayayyayy' + value.path);
      });
    }
  }

  Future<File> _downloadFile(String url, String filename) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    //App Document Directory + folder name
    final Directory _appDocDirFolder = Directory('$dir/gifts');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      dir = _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      dir = _appDocDirNewFolder.path;
    }
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  void initState() {
    apiCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Download Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LandingPage(),
    );
  }
}
