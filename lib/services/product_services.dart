import 'dart:io';

import 'package:flutter/material.dart';
import 'package:six_flutter_project/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsServices extends ChangeNotifier {
  final String _baseUrl = 'flutter-project-3b291-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;

  ///se ejecuta esta funcion apenas se llame a la clase [productServices]
  ProductsServices() {
    this.loadProducts();
  }

  ///Listado de productos donde se realiza la petción [http]
  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products2.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productMap = json.decode(resp.body);

    productMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });
    this.isLoading = false;
    notifyListeners();
    return this.products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      //es necesario crear
      await createProduct(product);
    } else {
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

//Actualiza la información
  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products2/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());
    // final decodeData = resp.body;
    // //respuesta del firebase
    // print(decodeData);
    //Actualizar el listado de productos en la vista
    final index =
        this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;

    return product.id!;
  }

  //Creacion de un nuevo producto
  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products2.json');
    final resp = await http.post(url, body: product.toJson());
    final decodeData = json.decode(resp.body);
    product.id = decodeData["name"];
    this.products.add(product);

    return product.id!;
  }

  void updateSelectImage(String path) {
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/di24rzv3c/image/upload/?upload_preset=e4rrp6nj');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Ocurrió un error');
      print(resp.body);
    }
    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];
  }
}
