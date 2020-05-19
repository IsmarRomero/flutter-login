import 'dart:io';

import 'package:flutter/material.dart';

import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:login/utils/shared_preferents.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // Authenticacion Huella
var localAuth = LocalAuthentication();
bool didAuthenticate  = false;

GlobalKey<FormState> _key = GlobalKey();
   RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');

   String _correo;
  String _contrasena;
  String mensaje = '';
  bool isAuthBiometric = false;
  String nameBiometry = '';

  @override
  void initState() { 
    super.initState();
    final prefs =  PreferenciasUsuario();
    isAuthBiometric = prefs.authBiometric;
    
  }

  Widget build(BuildContext context) {
    getNameBiometry();
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));

    if (isAuthBiometric) {
       _authenticate();
    }

    return Scaffold(
      body:
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white10, Colors.blue],
            stops: [0.05,0.4,1.0],
             begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              tileMode: TileMode.clamp
             )
          ),
       child: loginForm()
      ),
//      body: loginForm(),
    );
  }
   Widget loginForm() {
    return Column(
      
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
        
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(size: 100,)
          ],
        ),
        Container(
          width: 300.0, //size.width * .6,
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "Este campo correo es requerido";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "El formato para correo no es correcto";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Ingrese su Correo',
                    labelText: 'Correo',
                    counterText: '',
                    icon:
                        Icon(Icons.email, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) {},
                ),
                TextFormField(
                  validator: (text) {
                    if (text.length == 0) {
                      return "Este campo contraseña es requerido";
                    } else if (text.length <= 5) {
                      return "Su contraseña debe ser al menos de 5 caracteres";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Ingrese su Contraseña',
                    labelText: 'Contraseña',
                    counterText: '',
                    icon: Icon(Icons.lock, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _contrasena = text,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buttonReset(),
                    _buttonLogin(),
                ],)

              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buttonReset() {
    return IconButton(
      onPressed: (){
final prefs =  PreferenciasUsuario();
    isAuthBiometric = false;
      prefs.authBiometric = false;
      },
      icon: Icon(
            Icons.replay,
           size: 42.0,
               color: Colors.blue[800],
           ),
    );
  }

  Widget _buttonLogin(){
     return IconButton(
                  onPressed: () async {
                    print(didAuthenticate);
                    if (_key.currentState.validate()) {
                      _key.currentState.save();
                      //Aqui se llamaria a su API para hacer el login
                      getNameBiometry();
                if (nameBiometry.isEmpty) {
                    Navigator.of(context).pushReplacementNamed('menu');
                } else {
                    
                    _mostrarAlerta(context, nameBiometry);  
                }         
                     //  _getListOfBiometricTypes();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 42.0,
                    color: Colors.blue[800],
                  ),
                );
  }
    Future<void> _authenticate() async {
    try {
      didAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
           if (didAuthenticate) {
        final prefs =  PreferenciasUsuario();
        prefs.authBiometric = true;
        Navigator.of(context).pushReplacementNamed('menu');
      }

    } on PlatformException catch (e) {
      print(e);
    }
   //  if (!mounted) return;
  }

  Future getNameBiometry() async {
  List<BiometricType> availableBiometrics =
    await localAuth.getAvailableBiometrics();
    // bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
         nameBiometry = 'Face ID';
       } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
         nameBiometry = 'Touch ID';
         }
    } else {
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Face ID.
        nameBiometry = 'Huella';
       }
    }  
   // if (!canCheckBiometrics) nameBiometry = '';
  }

  _mostrarAlerta(BuildContext context, String nameBiometric) {

    final icon = Icon(nameBiometric == 'Face ID' ? Icons.face : Icons.fingerprint, size: 70.0, color: Colors.blue,);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
            ),
          title: Center(child:Text('Login APP')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Quieres ingresar la proxima vez por $nameBiometric'),
              icon,
                Row(
              
    mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
              onPressed: (){
              Navigator.of(context).pop();
            },
             child: Text('No')
             ),
            FlatButton(
              
              onPressed: () async { 
              Navigator.of(context).pop();
              await _authenticate();
            },
             child: Text('Si')
             ),
              ],
              )
            ],
          ),
          actions:null
        );
      }

      );
  }
}