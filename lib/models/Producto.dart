class Producto {
  int id;
  String nombre;
  String descripcion;
  int cantidad;
  num precioUnitario;
  bool vence;
  DateTime? fechaDeVencimiento;

  Producto(this.id, this.nombre, this.descripcion, this.cantidad, this.precioUnitario, this.vence, this.fechaDeVencimiento);
}
