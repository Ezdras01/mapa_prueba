import 'package:flutter/material.dart';
import '../widgets/responsive_scaffold.dart';
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

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    final data = await CsvLoader.getUniqueProducts();
    setState(() {
      productos = data;
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
        cargando: cargando,
      ),
      tablet: _TabletLayout(
        productos: productos,
        productoSeleccionado: productoSeleccionado,
        onProductoChanged: (value) => setState(() => productoSeleccionado = value),
        cargando: cargando,
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final List<String> productos;
  final String? productoSeleccionado;
  final Function(String?) onProductoChanged;
  final bool cargando;

  const _MobileLayout({
    required this.productos,
    required this.productoSeleccionado,
    required this.onProductoChanged,
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
          child: Container(
            color: Colors.grey[200],
            child: const Center(child: Text('Mapa de México')),
          ),
        ),
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
  final bool cargando;

  const _TabletLayout({
    required this.productos,
    required this.productoSeleccionado,
    required this.onProductoChanged,
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
                child: Container(
                  color: Colors.grey[200],
                  child: const Center(child: Text('Mapa de México')),
                ),
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
