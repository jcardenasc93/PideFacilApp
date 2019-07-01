class QRObject {
  int idMesa;
  int idRestaurante;
  String urlApiGet;

  QRObject({this.idMesa, this.idRestaurante, this.urlApiGet});

  factory QRObject.qrFromJson(Map<String, dynamic> parsedJson) {
    return QRObject(
        idMesa: parsedJson['idMesa'],
        idRestaurante: parsedJson['idRestaurante'],
        urlApiGet: parsedJson['urlAPI']);
  }
}
