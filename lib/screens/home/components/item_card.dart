import 'package:flutter/material.dart';
import 'Product.dart';
import 'color_filters.dart';



class ItemCard extends StatelessWidget {
  final Product product;
  final Function press;
  const ItemCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            image: AssetImage(
              product.image,
            ),
            colorFilter: ColorFilter.mode(Colors.white30, BlendMode.exclusion),
            height: 240,
            fit: BoxFit.cover,
            child: InkWell(
              onTap: press,
            ),
          ),
          Text(
            product.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}