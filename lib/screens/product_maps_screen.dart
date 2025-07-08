import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/responsive_scaffold.dart';
import '../models/cac_model.dart';
import '../services/csv_loader.dart';

class ProductMapScreen extends StatefulWidget {
  const ProductMapScreen({super.key});

  @override
  State<ProductMapScreen> createState() => _ProductMapScreenState();
}

class _ProductMapScreenState extends State<ProductMapScreen> {
  List<String> productos = [];
  String? productoSeleccionado;
  bool cargando = true;
  List<CAC> cacs = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final todos = await CsvLoader.loadCACs();
    final listaProductos = todos.map((e) => e.nombreProducto).toSet().toList()..sort();
    setState(() {
      cacs = todos;
      productos = listaProductos;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Centros de Acopio'),
        centerTitle: true,
      ),
      mobile: _MobileLayout(
        productos: productos,
        productoSeleccionado: productoSeleccionado,
        onProductoChanged: (value) => setState(() => productoSeleccionado = value),
        cacsFiltrados: _getCACsFiltrados(),
        cargando: cargando,
      ),
      tablet: _TabletLayout(
        productos: productos,
        productoSeleccionado: productoSeleccionado,
        onProductoChanged: (value) => setState(() => productoSeleccionado = value),
        cacsFiltrados: _getCACsFiltrados(),
        cargando: cargando,
      ),
    );
  }

  List<CAC> _getCACsFiltrados() {
    if (productoSeleccionado == null) return [];
    return cacs.where((c) => c.nombreProducto == productoSeleccionado).toList();
  }
}

class _MobileLayout extends StatelessWidget {
  final List<String> productos;
  final String? productoSeleccionado;
  final Function(String?) onProductoChanged;
  final List<CAC> cacsFiltrados;
  final bool cargando;

  const _MobileLayout({
    required this.productos,
    required this.productoSeleccionado,
    required this.onProductoChanged,
    required this.cacsFiltrados,
    required this.cargando,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: cargando
              ? const CircularProgressIndicator()
              : DropdownButton<String>(
                  value: productoSeleccionado,
                  isExpanded: true,
                  hint: const Text('Selecciona un producto'),
                  items: productos.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: onProductoChanged,
                ),
        ),
        Expanded(child: CACMap(cacs: cacsFiltrados)),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          color: Colors.blue[50],
          child: Text(
            productoSeleccionado == null
                ? 'Tarjeta con información del CAC'
                : 'Seleccionaste: $productoSeleccionado',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final List<String> productos;
  final String? productoSeleccionado;
  final Function(String?) onProductoChanged;
  final List<CAC> cacsFiltrados;
  final bool cargando;

  const _TabletLayout({
    required this.productos,
    required this.productoSeleccionado,
    required this.onProductoChanged,
    required this.cacsFiltrados,
    required this.cargando,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: cargando
              ? const CircularProgressIndicator()
              : DropdownButton<String>(
                  value: productoSeleccionado,
                  isExpanded: true,
                  hint: const Text('Selecciona un producto'),
                  items: productos.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: onProductoChanged,
                ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: CACMap(cacs: cacsFiltrados),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Text(
                    productoSeleccionado == null
                        ? 'Tarjeta con información del CAC'
                        : 'Seleccionaste: $productoSeleccionado',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CACMap extends StatelessWidget {
  final List<CAC> cacs;

  const CACMap({super.key, required this.cacs});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(23.6345, -102.5528),
        initialZoom: 5.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: cacs.map((cac) => Marker(
            width: 40,
            height: 40,
            point: LatLng(cac.lat, cac.lon),
            child: const Icon(Icons.location_on, color: Colors.red),
          )).toList(),
        )
      ],
    );
  }
}
