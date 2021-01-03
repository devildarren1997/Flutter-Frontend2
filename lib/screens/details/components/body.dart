import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/screens/home/components/Product.dart';
import 'package:fypapp/screens/uploadImage/uploadScreen.dart';
import 'package:fypapp/size_config.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: getProportionateScreenHeight(10)),
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                // Container of the description
                Container(
                  margin: EdgeInsets.only(top: size.height*0.42),
                  decoration: BoxDecoration(
                    color: kSecondaryBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    )
                  ),

                  // Content in the description
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          product.title,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headline4.copyWith(color: kTextColor, fontWeight: FontWeight.bold, fontFamily: 'Muli')
                        ),
                        SizedBox(height: 20),
                        Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 50),
                        Row(
                            children: <Widget>[
                              Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18)),
                                      color: product.color,
                                      onPressed: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => UploadScreen(
                                                  product: product,
                                                )
                                            ));
                                      },
                                      child: Text(
                                        "Embed  Text  Now".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),


                // Effect Image and Designer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Ink.image(
                                image: AssetImage(
                                  product.image,
                                ),
                                height: 300,
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: (){}
                                ),
                              ),
                              
                              Positioned(
                                bottom: 5,
                                right: 10,
                                left: 16,
                                child: Row(
                                  children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(text: "Designer\n", style: TextStyle(
                                          color: product.textColor, fontSize: 20,
                                        )),
                                        TextSpan(
                                          text: "${product.designer}",
                                          style: Theme.of(context).textTheme.headline4.copyWith(
                                              color: product.textColor, fontWeight: FontWeight.bold, fontFamily: 'Muli'
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
                
              ],
            ),
            
          ),
        ],
        
      ),
    );
  }
}