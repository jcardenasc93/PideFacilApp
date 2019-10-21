class Ubicacion {
  String place;

  Ubicacion({this.place});

  factory Ubicacion.fromJson(Map<String, dynamic> parsedJson) {
    return Ubicacion(place: parsedJson['ubicacion']);
  }
}
