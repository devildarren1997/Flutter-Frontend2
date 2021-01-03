import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../size_config.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:fypapp/global.dart' as globals;
import 'package:fypapp/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;


class Body extends StatefulWidget {

  final String jsonImage;

  const Body(this.jsonImage, {Key key}): super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var filePath;
  bool _isLoading = false;

  void share(BuildContext context) async {

    final RenderBox box = context.findRenderObject();
    final decodedBytes = base64Decode(widget.jsonImage);
    final appDir = await syspaths.getTemporaryDirectory();
    File file = File('${appDir.path}/embeddedImage.png');

    await file.writeAsBytesSync(decodedBytes);

    await Share.shareFile(file,
      subject: "This is the embedded Image",
      text: "Hello, you image has been embedded!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
    );


  }

  void _downloadImage()async{
    setState(() {
      _isLoading = true;
    });

    final decodedBytes = base64Decode(widget.jsonImage);
    String imagePath = globals.imagePath.split('/').last;
    String imageName = imagePath.split('.').first;
    final String path = ("/Pictures");
    File imageFile = new File("$path/MarkEmb/$imageName.png");
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(decodedBytes, flush: true);

    if(imageFile != null){
      Fluttertoast.showToast(
          msg: "Image saved to your gallery. Check your Gallery.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.tealAccent,
          textColor: Colors.black,
          fontSize: 16.0);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> saveImage() async{
  //   try{
  //     PermissionStatus storageStatus = await Permission.storage.status;
  //     if(storageStatus != PermissionStatus.granted){
  //       storageStatus = await Permission.storage.request();
  //       if(storageStatus != PermissionStatus.granted){
  //         throw 'Permission denied.Please allow permission to access the storage';
  //       }
  //     }
  //
  //     final decodedBytes = base64Decode(widget.jsonImage);
  //     final appDir = await syspaths.getTemporaryDirectory();
  //     File file = File('${appDir.path}/embeddedImage.png');
  //     var imageFile = await file.writeAsBytesSync(decodedBytes);
  //     final result = await ImageGallerySaver.saveFile(imageFile, isReturnPathOfIOS: false );
  //
  //     if(result == null || result == '')throw 'Image save failed';
  //
  //     print("Saved Success");
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }

  Widget _displayImageView(){
      return Container(
        child: Image.memory(base64Decode(widget.jsonImage)),
        height: 400,
        width: 400,
        alignment: Alignment.topCenter,
      );
  }

  Widget _circularShareButton(){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              height: 70,
              width: 70,
              child: IconButton(
                icon: Icon(Icons.share_rounded),
                iconSize: 30,
                onPressed: (){
                   share(context);
                },
              ),
            ),
            Container(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              height: 70,
              width: 70,
              child: IconButton(
                icon: Icon(Icons.save_alt_rounded),
                iconSize: 40,

                onPressed: (){
                  _downloadImage();
                },
              ),),
          ],
        ),
    );
  }

  Widget _HomeButton(){
    return Row(
      children: [
        Expanded(
            child: SizedBox(
              height: 50,
              child: MaterialButton(
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                onPressed: () async{
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()), (
                      Route<dynamic> route) => false);
                },
                child: Text(
                  "Return to Home".toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    return _isLoading ? Center(child: CircularProgressIndicator()):SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
            child: SingleChildScrollView(
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Text(
                      "You have done embedding",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                    "Share Save OR Return to Home",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    _displayImageView(),
                    _circularShareButton(),
                    SizedBox(height: SizeConfig.screenHeight * 0.005),
                    _HomeButton(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                  ],
                ),
            ),
        ),
      ),
    );
  }
}
