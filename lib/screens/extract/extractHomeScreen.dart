import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fypapp/screens/home/home_screen.dart';

import '../../constants.dart';
import 'components/body.dart';

class ExtractHomeScreen extends StatefulWidget {
  static String routeName = "/extract_home";

  @override
  _ExtractHomeScreenState createState() => _ExtractHomeScreenState();
}

class _ExtractHomeScreenState extends State<ExtractHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        title: Text(
          'Extract Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Muli',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Body(),
      bottomNavigationBar: CurvedNavigationBar(
        color: kBackground,
        backgroundColor: kSecondaryBackground,
        buttonBackgroundColor: kIconColor,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home_outlined, size: 20.0, color: Colors.white),
          Icon(Icons.lock_outlined, size: 20.0, color: Colors.white),
        ],
        animationCurve: Curves.easeIn,
        animationDuration: Duration(
            milliseconds: 300
        ),
        index: 1,
        onTap: (index) {
          setState(() {
            if(index == 0){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()));
            }
          });
        },
      ),
    );
  }
}
