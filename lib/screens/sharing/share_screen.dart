import 'package:flutter/material.dart';
import 'components/body.dart';


class ShareScreen extends StatelessWidget {

  final String jsonImage;

  const ShareScreen(this.jsonImage, {Key key}): super(key: key);

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
      body: Body(jsonImage),
    );
  }
}
