import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/cac_model.dart';

class CsvLoader {
  static Future<List<CAC>> loadCACs() async {
    try {
      print('🔄 Intentando cargar el CSV...');
      final rawData = await rootBundle.loadString('assets/doc/cacs_limpios.csv');
      print('✅ CSV cargado con éxito');
      final List<List<dynamic>> csvData = const CsvToListConverter().convert(rawData, eol: '\n');
      final data = csvData.skip(1).map((row) => CAC.fromList(row)).toList();
      print('📦 Total de filas: ${data.length}');
      return data;
    } catch (e) {
      print('❌ Error al cargar CSV: $e');
      return [];
    }
  }

  static Future<List<String>> getUniqueProducts() async {
    final cacs = await loadCACs();
    final products = cacs.map((e) => e.nombreProducto).toSet().toList();
    products.sort();
    print('🟢 Productos únicos encontrados: ${products.length}');
    return products;
  }
}

