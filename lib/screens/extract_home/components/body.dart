import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fypapp/screens/extract/extractScreen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:fypapp/screens/home/components/Product.dart';

class Body extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Select",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Muli', fontSize: 25, fontWeight: FontWeight.bold, color: kTextColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Correct effect for the extraction",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Muli', fontSize: 16, fontWeight: FontWeight.w400, color: kTextColor,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          Expanded(
            flex: 2,
              child:
                  Container(
                    child: Column(
                      children: <Widget>[
                        CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              height: MediaQuery.of(context).size.height * 0.6,
                              enlargeCenterPage: true,
                              aspectRatio: 16/9,
                              scrollDirection: Axis.horizontal,
                              autoPlayInterval: Duration(
                                seconds: 2,
                              ),
                             autoPlayAnimationDuration: Duration(milliseconds: 1000),
                            ),
                          items: imageSliders,
                        ),
                      ],
                    ),
                  ),
              ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
        ],
      ),
    );
  }

  final List<Widget> imageSliders = products.map((item){
    return Builder(builder: (BuildContext context){
      return GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExtractScreen(item.filter),
              )
          );
        },
        child:
           Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      item.image,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'Designer: ${item.designer}\nEffect: ${item.title}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
      );
    });
  }).toList();
}
