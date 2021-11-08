import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:six_flutter_project/models/models.dart';
import 'package:six_flutter_project/screens/screens.dart';
import 'package:six_flutter_project/services/services.dart';
import 'package:six_flutter_project/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static final String routeName = "home_screen";
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsServices>(context);

    if (productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            productsService.selectedProduct =
                productsService.products[index].copy();
            Navigator.pushNamed(context, ProductScreen.routeName);
          },
          child: ProductCard(product: productsService.products[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            productsService.selectedProduct =
                new Product(aviable: false, name: '0', price: 0.0);
            Navigator.pushNamed(context, ProductScreen.routeName);
          }),
    );
  }
}
