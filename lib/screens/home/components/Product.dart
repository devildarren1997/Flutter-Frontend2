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

List<Product> products = [
  Product(
      id: 1,
      filter: "fragment",
      title: "Mosaic Filter",
      price: 234,
      designer: "Gong Chenyue",
      description: "Data is embedded into the Mosaic Effect. This algorithm requires PNG type images. It is good to apply on images with few elements.",
      image: 'assets/images/mosaic.png',
      color: Colors.green,
      textColor: Colors.white,

  ),

  Product(
      id: 2,
      filter: "pencil",
      title: "Pencil Drawing",
      price: 234,
      designer: "Gong Chenyue",
      description: "Data is embedded into the pencil drawing effect. This algorithm requires PNG type images. It is good to apply on image with high color contrast.",
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
      description: "Data is embedded into the image through pixel extension. This algorithm will be good for image with high color contrast.",
      image: 'assets/images/pixelextension.png',
      color: Colors.deepPurpleAccent,
      textColor: Colors.greenAccent,

  ),
  Product(
      id: 4,
      filter: "collageseffect",
      title: "Collage",
      price: 234,
      designer: "Tan Qing Lin",
      description: "Data is embedded into the border created in the image. The embedding algorithm utilized the RGB value of pixels at image border.",
      image: 'assets/images/collagesEffect.png',
      color: Color(0x9FE6B399),
      textColor: Colors.white,
  ),
];