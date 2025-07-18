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
  List<CAC> cacs = [];
  List<String> productos = [];
  String? productoSeleccionado;
  CAC? cacSeleccionado;
  bool cargando = true;

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

  List<CAC> _getFiltrados() {
    if (productoSeleccionado == null) return [];
    return cacs.where((c) => c.nombreProducto == productoSeleccionado).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cacsFiltrados = _getFiltrados();

    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('Centros de Acopio')),
      mobile: _MobileLayout(
        productos: productos,
        productoSeleccionado: productoSeleccionado,
        onProductoChanged: (value) {
          setState(() {
            productoSeleccionado = value;
            cacSeleccionado = null;
          });
        },
        cacsFiltrados: cacsFiltrados,
        cacSeleccionado: cacSeleccionado,
        onMarkerTap: (cac) => setState(() => cacSeleccionado = cac),
        cargando: cargando,
      ),
      tablet: _TabletLayout(
        productos: productos,
        productoSeleccionado: productoSeleccionado,
        onProductoChanged: (value) {
          setState(() {
            productoSeleccionado = value;
            cacSeleccionado = null;
          });
        },
        cacsFiltrados: cacsFiltrados,
        cacSeleccionado: cacSeleccionado,
        onMarkerTap: (cac) => setState(() => cacSeleccionado = cac),
        cargando: cargando,
      ),
      tabletPortrait: _TabletLayout(
        productos: productos,
        productoSeleccionado: productoSeleccionado,
        onProductoChanged: (value) {
          setState(() {
            productoSeleccionado = value;
            cacSeleccionado = null;
          });
        },
        cacsFiltrados: cacsFiltrados,
        cacSeleccionado: cacSeleccionado,
        onMarkerTap: (cac) => setState(() => cacSeleccionado = cac),
        cargando: cargando,
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final List<String> productos;
  final String? productoSeleccionado;
  final Function(String?) onProductoChanged;
  final List<CAC> cacsFiltrados;
  final CAC? cacSeleccionado;
  final Function(CAC) onMarkerTap;
  final bool cargando;

  const _MobileLayout({
    required this.productos,
    required this.productoSeleccionado,
    required this.onProductoChanged,
    required this.cacsFiltrados,
    required this.cacSeleccionado,
    required this.onMarkerTap,
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
        Expanded(child: CACMap(cacs: cacsFiltrados, onMarkerTap: onMarkerTap)),
        CACInfoCard(cac: cacSeleccionado),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final List<String> productos;
  final String? productoSeleccionado;
  final Function(String?) onProductoChanged;
  final List<CAC> cacsFiltrados;
  final CAC? cacSeleccionado;
  final Function(CAC) onMarkerTap;
  final bool cargando;

  const _TabletLayout({
    required this.productos,
    required this.productoSeleccionado,
    required this.onProductoChanged,
    required this.cacsFiltrados,
    required this.cacSeleccionado,
    required this.onMarkerTap,
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
                child: CACMap(cacs: cacsFiltrados, onMarkerTap: onMarkerTap),
              ),
              Expanded(
                flex: 1,
                child: CACInfoCard(cac: cacSeleccionado),
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
  final Function(CAC) onMarkerTap;

  const CACMap({super.key, required this.cacs, required this.onMarkerTap});

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
            child: GestureDetector(
              onTap: () => onMarkerTap(cac),
              child: const Icon(Icons.location_on, color: Colors.red),
            ),
          )).toList(),
        )
      ],
    );
  }
}

class CACInfoCard extends StatelessWidget {
  final CAC? cac;

  const CACInfoCard({super.key, required this.cac});

  @override
  Widget build(BuildContext context) {
    if (cac == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        color: Colors.blue[50],
        child: const Text(
          'Selecciona un marcador para ver la información',
          textAlign: TextAlign.center,
        ),
      );
    }

if (cac == null) return const SizedBox();

return Container(
  padding: const EdgeInsets.all(16),
  width: double.infinity,
  color: Colors.blue[50],
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('CAC: ${cac!.cacNombre}', style: const TextStyle(fontWeight: FontWeight.bold)),
      Text('Clave: ${cac!.cacClave}'),
      const SizedBox(height: 8),
      Text('Producto: ${cac!.nombreProducto}'),
      Text('Cantidad: ${cac!.cantidad} ${cac!.unidad}'),
      const SizedBox(height: 8),
      Text('Técnico: ${cac!.tecnicoResponsable}'),
      Text('📞 ${cac!.tecnicoCelular}'),
      const SizedBox(height: 8),
      Text('Proveedor: ${cac!.proveedor}'),
      Text('📞 ${cac!.proveedorCelular}'),
    ],
  ),
);

  }
}
