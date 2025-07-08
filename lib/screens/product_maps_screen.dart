import 'package:flutter/material.dart';
import '../widgets/responsive_scaffold.dart';

class ProductMapScreen extends StatelessWidget {
  const ProductMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Centros de Acopio'),
        centerTitle: true,
      ),
      mobile: const _MobileLayout(),
      tablet: const _TabletLayout(),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<String>(
            value: null,
            hint: const Text('Selecciona un producto'),
            items: const [],
            onChanged: null,
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
          child: const Text(
            'Tarjeta con información del CAC',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<String>(
            value: null,
            hint: const Text('Selecciona un producto'),
            items: const [],
            onChanged: null,
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
                  child: const Text(
                    'Tarjeta con información del CAC',
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
