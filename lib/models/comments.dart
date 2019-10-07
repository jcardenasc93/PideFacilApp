class Comment {
  String nombreCliente; //nombre del cliente.
  String address; // direccion de envio
  String phone; // celular cliente
  String obserbations; // Comentarios sobre la orden

  Comment({this.nombreCliente, this.address, this.phone, this.obserbations});

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    return Comment(
        nombreCliente: parsedJson['nombre_cliente'],
        address: parsedJson['direccion_envio'],
        phone: parsedJson['tel_cliente'],
        obserbations: parsedJson['comentarios']);
  }

  /// Generates the [map] object with desired json format.
  Map<String, dynamic> toJson() {
    return {
      'nombre_cliente:': nombreCliente,
      'direccion_envio': address,
      'tel_cliente': phone,
      'comentarios': obserbations
    };
  }

  /// Pass a list of [Comment] to [toJson] function to serialize in json format.
  static List encodeToJson(List<Comment> comments) {
    List jsonList = List();
    comments.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }
}
