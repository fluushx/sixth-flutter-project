// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

class Product {
  Product({
    required this.aviable,
    required this.name,
    this.picture,
    required this.price,
    this.id,
  });

  bool aviable;
  String? name;
  String? picture;
  double price;
  String? id;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        aviable: json["aviable"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "aviable": aviable,
        "name": name,
        "picture": picture,
        "price": price,
      };

  Product copy() => Product(
      aviable: this.aviable,
      name: this.name,
      picture: this.picture,
      price: this.price,
      id: this.id);
}
