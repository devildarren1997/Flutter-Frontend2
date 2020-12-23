import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/details/details_screen.dart';
import 'package:fypapp/size_config.dart';

import 'Product.dart';
import 'item_card.dart';

class Body extends StatelessWidget{


  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: getProportionateScreenHeight(20)),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Welcome to MarkEmb!\nThese are the effects in our App",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Muli', fontSize: 20, fontWeight: FontWeight.w400, color: kTextColor,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: products.length,
                itemBuilder: (context, index) => ItemCard(
                  product: products[index],
                  press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            product: products[index],
                          )
                      )),
                ),)),
      ],
    );
  }

}