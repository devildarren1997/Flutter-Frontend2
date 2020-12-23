import 'package:flutter/material.dart';
import 'body.dart';

class Product {
  final String image, title, description, designer, filter;
  final int price, id;
  final Color color;
  Product({
    this.id,
    this.filter,
    this.image,
    this.title,
    this.price,
    this.description,
    this.designer,
    this.color,
  });
}


String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";



List<Product> products = [
  Product(
      id: 1,
      filter: "fragment",
      title: "First Effect",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/catImage.jpg',
      color: Color(0xFF979797)),
  Product(
      id: 2,
      filter: "pencil",
      title: "Second Effect",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/catImage.jpg',
      color: Color(0xFFC2A121)),
  Product(
      id: 3,
      filter: "extension",
      title: "Third Effect",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/catImage.jpg',
      color: Color(0xFF989493)),
  Product(
      id: 4,
      filter: "collages",
      title: "Fourth Effect",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/catImage.jpg',
      color: Color(0xFFE6B399)),
];