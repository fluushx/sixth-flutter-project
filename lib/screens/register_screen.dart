import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:six_flutter_project/providers/login_form_provider.dart';
import 'package:six_flutter_project/screens/login_screen.dart';
import 'package:six_flutter_project/screens/screens.dart';
import 'package:six_flutter_project/services/services.dart';
import 'package:six_flutter_project/ui/input_decoration.dart';
import 'package:six_flutter_project/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  static final String routeName = "register_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 250),
            CardContainer(
                child: Column(children: [
              SizedBox(height: 10),
              Text('Register',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w100)),
              SizedBox(height: 30),
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: _LoginForm(),
              ),
            ])),
            SizedBox(height: 50),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, LoginScreen.routeName),
              child: Text('¿Ya tienes cuenta?',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold)),
              style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                shape: MaterialStateProperty.all(StadiumBorder()),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Colors.black),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInpuDecoration(
                  hintText: 'felipe.zapata@transvip.cl',
                  labelText: 'Correo Electronico',
                  prefixIcon: Icons.mark_email_read_sharp),
              onChanged: (value) {
                loginForm.email = value;
              },
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no corresponde a un correo ';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              style: TextStyle(color: Colors.black),
              autocorrect: false,
              obscureText: true,
              onChanged: (value) {
                loginForm.password = value;
              },
              decoration: InputDecorations.authInpuDecoration(
                  hintText: '*******',
                  labelText: 'Ingresar Contraseña',
                  prefixIcon: Icons.lock_outline),
              validator: (value) {
                return (value != null) && (value.length >= 6)
                    ? null
                    : 'La contraseña debe tener minimo 6 caracteres';
              },
            ),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                    child: Text(loginForm.isLoading ? 'Espere' : 'Ingresar',
                        style: TextStyle(color: Colors.white))),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        //TODO: Validar si el register es correcto
                        final String? errorMessage = await authService
                            .createUser(loginForm.email, loginForm.password);
                        if (errorMessage == null) {
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        } else {
                          print(errorMessage);
                        }

                        loginForm.isLoading = false;
                      })
          ],
        ),
      ),
    );
  }
}
