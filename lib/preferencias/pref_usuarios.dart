import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuarios {
  // inicializar la instancia
  static late SharedPreferences _prefs;

//inicualizar las preferencas
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // hacer el get y el set

  String get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? '/index';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  String get ultimouid {
    return _prefs.getString('ultimouid') ?? '';
  }

  set ultimouid(String value) {
    _prefs.setString('ultimouid', value);
  }

  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }
}
