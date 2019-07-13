import './platos_model.dart';
class Menu {
  int idMenu;
  String nombreMenu;
  List<Plato> platoMenu;

  Menu({this.idMenu, this.nombreMenu, this.platoMenu});

  factory Menu.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['plato_menu'] as List;
    List<Plato> platoList = list.map((i) => Plato.fromJson(i)).toList();
    return Menu(
      idMenu: parsedJson['id'],
      nombreMenu: parsedJson['nombre_menu'],
      platoMenu: platoList);

  }
}
