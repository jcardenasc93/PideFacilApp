class Menu {
  //int idRestaurante;
  String nombreMenu;

  //Menu({this.idRestaurante, this.nombreMenu});
  Menu({this.nombreMenu});

  factory Menu.fromJson(Map<String, dynamic> parsedJson) {
    return Menu(nombreMenu: parsedJson['nombre_menu']);
  }
}
