import 'package:flutter/material.dart';
import 'package:six_flutter_project/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _CardBordesDecoration(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(product.picture),
            _ProductDetail(
              nombreProducto: '${product.name}',
              idProducto: '${product.id}',
            ),
            Positioned(
                top: 0,
                right: 0,
                child: _PriceTag(
                  price: '${product.price}',
                )),
            if (!product.aviable)
              Positioned(
                  top: 0,
                  left: 0,
                  child: _NotAviable(
                    notAviable: '${product.aviable}',
                  )),
          ],
        ),
      ),
    );
  }

  BoxDecoration _CardBordesDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 7),
            )
          ]);
}

class _NotAviable extends StatelessWidget {
  final String notAviable;

  const _NotAviable({Key? key, required this.notAviable}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('No Disponible',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
      ),
      decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final String price;

  const _PriceTag({Key? key, required this.price}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            '\$ $price',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
      alignment: Alignment.center,
    );
  }
}

class _ProductDetail extends StatelessWidget {
  final String nombreProducto;
  final String idProducto;

  const _ProductDetail(
      {Key? key, required this.nombreProducto, required this.idProducto})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: double.infinity,
        height: 80,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$nombreProducto',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text('$idProducto',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage(this.url);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(60),
      child: Container(
          width: double.infinity,
          height: 400,
          color: Colors.green,
          child: url == null
              ? Image(
                  image: AssetImage('assets/no-image.png'), fit: BoxFit.cover)
              : FadeInImage(
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(url!),
                  fit: BoxFit.cover,
                )),
    );
  }
}
