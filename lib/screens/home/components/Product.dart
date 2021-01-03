import 'package:flutter/material.dart';
import 'body.dart';

class Product {
  final String image, title, description, designer, filter;
  final int price, id;
  final Color color, textColor;
  Product({
    this.id,
    this.filter,
    this.image,
    this.title,
    this.price,
    this.description,
    this.designer,
    this.color,
    this.textColor,
  });
}


String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";



List<Product> products = [
  Product(
      id: 1,
      filter: "fragment",
      title: "Mosaic Filter",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/mosaic.png',
      color: Color(0xFF979797),
      textColor: Colors.white,

  ),

  Product(
      id: 2,
      filter: "pencil",
      title: "Pencil Drawing",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/pencil.jpeg',
      color: Color(0xFFC2A121),
      textColor: Colors.black,

  ),
  Product(
      id: 3,
      filter: "pixelextension",
      title: "Pixel Extension",
      price: 234,
      designer: "Tan Qing Lin",
      description: "Data is embedded into the image through pixel extension. This algorithm requires high precision of pixels' RGB value. "
          "Image with pixel's RGB value that is nearly the same will have big chance to get error in extraction.",
      image: 'assets/images/pixelextension.png',
      color: Colors.deepPurpleAccent,
      textColor: Colors.limeAccent,

  ),
  Product(
      id: 4,
      filter: "collageseffect",
      title: "Collage",
      price: 234,
      designer: "Tan Qing Lin",
      description: dummyText,
      image: 'assets/images/collages.jpg',
      color: Color(0xFFE6B399),
      textColor: Colors.white,
  ),
];