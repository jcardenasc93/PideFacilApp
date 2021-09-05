import './menu_model.dart';

class Restaurante {
  final int id;
  final String nombreRestaurante;
  final String urlImagRestaurante;
  final String externalImage;
  final List<Menu> menus;

  Restaurante(
      {this.id,
      this.nombreRestaurante,
      this.urlImagRestaurante,
      this.externalImage,
      this.menus});

  factory Restaurante.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['menu_restaurante'] as List;
    List<Menu> menusList = list.map((i) => Menu.fromJson(i)).toList();
    return Restaurante(
        id: parsedJson['id'],
        nombreRestaurante: parsedJson['nombre_restaurante'],
        urlImagRestaurante: parsedJson['url_imagen_restaurante'],
        externalImage: parsedJson['url_imagen_restaurante'],
        menus: menusList);
  }
}
