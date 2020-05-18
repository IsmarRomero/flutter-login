import 'package:flutter/material.dart';
import 'package:login/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:login/pages/menu_page.dart';
import 'package:login/utils/shared_preferents.dart';
 
void main() async  {
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
} 
 
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login APP',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'menu' : (BuildContext context) => MenuPage(),
      } ,
    );
  }
}