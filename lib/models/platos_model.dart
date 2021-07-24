class Plato {
  int idPlato; //id.
  String nombrePlato; //nombre_plato.
  int precioPlato; //precio.
  int precioTotalPlato = 0; // precio * cantidad.
  String descripcionPlato = ''; //descripcion.
  int cantidad = 0;
  String comment;

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
        descripcionPlato: parsedJson['descripcion']);
  }

  /// Generates the [map] object with desired json format.
  Map<String, dynamic> toJson() {
    return {"id_plato": idPlato, "cantidad": cantidad, "comment": comment};
  }

  /// Pass a list of [Platos] to [toJson] function to serialize in json format.
  static List encodeToJson(List<Plato> platos) {
    List jsonList = [];
    platos.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }
}
