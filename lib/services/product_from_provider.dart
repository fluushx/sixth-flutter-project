import 'package:flutter/material.dart';
import 'package:six_flutter_project/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  //se guarda la referencia del formulario
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    print(value);
    this.product.aviable = value;
    notifyListeners();
  }

  //validaciones del form
  bool isValidForm() {
    print(product.name);
    print(product.price);
    print(product.aviable);
    return formKey.currentState?.validate() ?? false;
  }
}
