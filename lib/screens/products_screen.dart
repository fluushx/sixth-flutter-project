import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:six_flutter_project/services/services.dart';
import 'package:six_flutter_project/ui/input_decoration.dart';
import 'package:six_flutter_project/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static final String routeName = "product_screen";
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsServices>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductScreenBody(productsService: productsService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsServices productsService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(
                      urlImage: productsService.selectedProduct.picture),
                  Positioned(
                      top: 60,
                      left: 10,
                      child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back_ios_new,
                              size: 40, color: Colors.white))),
                  Positioned(
                      top: 60,
                      right: 30,
                      child: IconButton(
                          onPressed: () async {
                            //TODO: Seleccionar camara o galeria
                            final picker = new ImagePicker();
                            final PickedFile? pickedFile = await picker
                                // ignore: deprecated_member_use
                                .getImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 100);
                            if (pickedFile == null) {
                              print(" No se seleccionó nada");
                            } else {
                              print("tenemos imagen ${pickedFile.path}");
                            }
                            productsService.updateSelectImage(pickedFile!.path);
                          },
                          icon: Icon(Icons.camera_alt_outlined,
                              size: 40, color: Colors.white))),
                ],
              ),
              _ProductForm(),
              SizedBox(height: 100),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: productsService.isSaving
              ? CircularProgressIndicator(color: Colors.white)
              : Icon(Icons.save_alt_outlined, color: Colors.white),
          onPressed: productsService.isSaving
              ? null
              : () async {
                  if (!productForm.isValidForm()) return;
                  final String? imageUrl = await productsService.uploadImage();
                  if (imageUrl != null) productForm.product.picture = imageUrl;
                  productsService.saveOrCreateProduct(productForm.product);

                  //Guardar producto
                },
        ));
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: [
            SizedBox(height: 10),
            TextFormField(
              initialValue: product.name,
              onChanged: (value) {
                product.name = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
              },
              decoration: InputDecorations.authInpuDecoration(
                  hintText: 'Nombre del producto', labelText: 'Nombre:'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 30),
            TextFormField(
              initialValue: '${product.price}',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              onChanged: (value) {
                if (double.tryParse(value) == null) {
                  product.price = 0;
                } else {
                  product.price = double.parse(value);
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInpuDecoration(
                  hintText: '\$', labelText: 'Precio:'),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 30),
            SwitchListTile.adaptive(
                title:
                    Text('Disponible', style: TextStyle(color: Colors.black)),
                value: product.aviable,
                activeColor: Colors.indigo,
                onChanged: (value) {
                  productForm.updateAvailability(value);
                }),
            SizedBox(height: 50),
          ]),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5)
        ]);
  }
}
