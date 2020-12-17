import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';

class Product {
  final String image, title, description, designer;
  final int price, id;
  final Color color;
  Product({
    this.id,
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
      title: "First Effect",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/catImage.jpg',
      color: Color(0xff24292B)),
  Product(
      id: 2,
      title: "Second Effect",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/catImage.jpg',
      color: Color(0xFFC2A121)),
  Product(
      id: 3,
      title: "Third Effect",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/catImage.jpg',
      color: Color(0xFF989493)),
  Product(
      id: 4,
      title: "Fourth Effect",
      price: 234,
      designer: "Gong Chenyue",
      description: dummyText,
      image: 'assets/images/catImage.jpg',
      color: Color(0xFFE6B399)),
];