import './platos_model.dart';

class Mesa {
  int idMesa;
  List<Plato> orden = <Plato>[];

  Mesa({this.idMesa, this.orden});
}
