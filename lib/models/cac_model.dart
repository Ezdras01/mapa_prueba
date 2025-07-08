class CAC {
  final String nombreProducto;
  final int cantidad;
  final String unidad;
  final String calidad;
  final String proveedor;
  final String proveedorCelular;
  final String tecnicoResponsable;
  final String tecnicoCelular;
  final String cacNombre;
  final String cacClave;
  final double lat;
  final double lon;

  CAC({
    required this.nombreProducto,
    required this.cantidad,
    required this.unidad,
    required this.calidad,
    required this.proveedor,
    required this.proveedorCelular,
    required this.tecnicoResponsable,
    required this.tecnicoCelular,
    required this.cacNombre,
    required this.cacClave,
    required this.lat,
    required this.lon,
  });

  factory CAC.fromList(List<dynamic> row) {
    return CAC(
      nombreProducto: row[0].toString(),
      cantidad: int.tryParse(row[1].toString()) ?? 0,
      unidad: row[2].toString(),
      calidad: row[3].toString(),
      proveedor: row[4].toString(),
      proveedorCelular: row[5].toString(),
      tecnicoResponsable: row[6].toString(),
      tecnicoCelular: row[7].toString(),
      cacNombre: row[8].toString(),
      cacClave: row[9].toString(),
      lat: double.tryParse(row[10].toString()) ?? 0,
      lon: double.tryParse(row[11].toString()) ?? 0,
    );
  }
}
