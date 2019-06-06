class Menu {
  int idRestaurante;
  String nombreMenu;

  Menu({this.idRestaurante, this.nombreMenu});

  factory Menu.fromJson(Map<String, dynamic> parsedJson) {
    return Menu(
      idRestaurante: parsedJson['id_restaurante'],
      nombreMenu: parsedJson['nombre_menu']
    );
  }
}