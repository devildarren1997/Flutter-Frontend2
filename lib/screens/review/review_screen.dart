import 'package:flutter/material.dart';

import 'components/body.dart';

class ReviewScreen extends StatelessWidget {
  final String jsonImage;

  const ReviewScreen(this.jsonImage, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Review Image',
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
