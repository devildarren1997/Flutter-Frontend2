import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/extract_home/extract_home_screen.dart';
import 'package:fypapp/screens/sign_in/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/body.dart';


class HomeScreen extends StatefulWidget{
  static String routeName = "/home";

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => SignInScreen()), (
          Route<dynamic> route) => false);
    }
  }

  Future<void> _showContactDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text("Contact Us: ",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: RichText(
              text: TextSpan(
                text: "Kindly contact us at:",
                style: TextStyle(color: Colors.black, fontSize: 19, fontFamily: "Muli"),
                children: <TextSpan>[
                  TextSpan(
                      text: "\nembedapptesting@gmail.com",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            // Text("Kindly contact us at:\nembedapptesting@gmail.com",
            //   style: TextStyle(color: Colors.black, fontSize: 18),
            // ),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Close"))
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Muli',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: SvgPicture.asset('assets/icons/Call.svg'),
              onPressed: () {
                _showContactDialog(context);
              }
              ),
          IconButton(
              icon: SvgPicture.asset('assets/icons/Log out.svg'),
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (BuildContext context) => SignInScreen()), (
                    Route<dynamic> route) => false);

                Fluttertoast.showToast(
                    msg: "You have logged out",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.tealAccent,
                    textColor: Colors.black,
                    fontSize: 15.0);

              }),
        ],
        bottom: PreferredSize(
          child: Container(
            color: Colors.lime,
            height: 2.0,
          ),
          preferredSize: Size.fromHeight(2.0),
        ),
      ),
      body: Body(),
      bottomNavigationBar: CurvedNavigationBar(
        color: kBackground,
        backgroundColor: kSecondaryBackground,
        buttonBackgroundColor: kIconColor,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home_outlined, size: 20.0, color: Colors.white),
          Icon(Icons.lock_open_outlined, size: 20.0, color: Colors.white),
        ],
        animationCurve: Curves.easeIn,
        animationDuration: Duration(
            milliseconds: 300
        ),
        index: 0,
        onTap: (index) {
          setState(() {
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ExtractHomeScreen()));
            }
          });
        },
      ),
    );
  }
}
  

// class HomeScreen extends StatelessWidget {
//   static String routeName = "/home";
//   final DetailsScreen _detailsScreen = new DetailsScreen();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Home',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Muli',
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         bottom: PreferredSize(
//           child: Container(
//             color: Colors.lime,
//             height: 2.0,
//           ),
//           preferredSize: Size.fromHeight(2.0),
//         ),
//       ),
//       body: Body(),
//       bottomNavigationBar: CurvedNavigationBar(
//         color: kBackground,
//         backgroundColor: kSecondaryBackground,
//         buttonBackgroundColor: kIconColor,
//         height: 50.0,
//         items: <Widget>[
//           Icon(Icons.lock_outlined, size: 20.0, color: Colors.white),
//           Icon(Icons.home_outlined, size: 20.0, color: Colors.white),
//         ],
//         animationCurve: Curves.easeIn,
//         animationDuration: Duration(
//           milliseconds: 300
//         ),
//         index: 1,
//         onTap: (index) {
//           setState(() {
//             _page = index;
//           });
//         },
//       ),
//     );
//   }
// }

