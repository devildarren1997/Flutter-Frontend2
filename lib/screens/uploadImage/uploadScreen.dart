import 'package:flutter/material.dart';
import 'package:fypapp/screens/home/components/Product.dart';

import 'components/body.dart';



class UploadScreen extends StatefulWidget {
  static String routeName = "/upload_image";

  final Product product;
  const UploadScreen({Key key, this.product}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Access Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Muli',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Body(product: widget.product),
    );
  }
}
