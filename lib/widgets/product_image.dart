import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:six_flutter_project/services/product_from_provider.dart';
import 'package:six_flutter_project/services/services.dart';
import 'dart:io';

class ProductImage extends StatelessWidget {
  final String? urlImage;

  const ProductImage({Key? key, this.urlImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsServices>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: _buildBoxDecoration(),
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            child: getImage(urlImage),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ]);

  Widget getImage(String? picture) {
    if (picture == null)
      return Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover);

    if (picture.startsWith('http'))
      return FadeInImage(
          image: NetworkImage(this.urlImage!),
          placeholder: AssetImage('assets/jar-loading.gif'),
          fit: BoxFit.cover);
    return Image.file(File(picture), fit: BoxFit.cover);
  }
}
