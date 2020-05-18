import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }


  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    WidgetsFlutterBinding.ensureInitialized();
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET authBiometric
  get authBiometric {
    return _prefs.getBool('auth') ?? false;
  }

  set authBiometric (bool value){
    _prefs.setBool('auth', value);
  }

}