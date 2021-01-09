import 'package:bg_download_test/gift_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BG Download Test'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => GiftPage())),
          child: Text('Go!'),
        ),
      ),
    );
  }
}
