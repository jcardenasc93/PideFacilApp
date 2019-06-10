class Plato {
  int idPlato; //id
  String nombrePlato; //nombre_plato
  int precioPlato; //precio
  String descripcionPlato; //descripcion

  Plato(
      {this.idPlato,
      this.nombrePlato,
      this.precioPlato,
      this.descripcionPlato});

  factory Plato.fromJson(Map<String, dynamic> parsedJson) {
    return Plato(
      idPlato: parsedJson['id'],
      nombrePlato: parsedJson['nombre_plato'],
      precioPlato: parsedJson['precio'],
      descripcionPlato: parsedJson['descripcion']
    );
  }
}
