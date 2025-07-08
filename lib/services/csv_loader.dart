import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/cac_model.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class CsvLoader {
  static Future<List<CAC>> loadCACs() async {
    try {
      _logger.i('🔄 Intentando cargar el CSV...');
      final rawData = await rootBundle.loadString('assets/doc/cacs_limpios.csv');
      _logger.i('✅ CSV cargado con éxito');
      final List<List<dynamic>> csvData = const CsvToListConverter().convert(rawData, eol: '\n');
      final data = csvData.skip(1).map((row) => CAC.fromList(row)).toList();
      _logger.i('📦 Total de filas: ${data.length}');
      return data;
    } catch (e) {
      _logger.e('❌ Error al cargar CSV: $e');
      return [];
    }
  }

  static Future<List<String>> getUniqueProducts() async {
    final cacs = await loadCACs();
    final products = cacs.map((e) => e.nombreProducto).toSet().toList();
    products.sort();
    _logger.i('🟢 Productos únicos encontrados: ${products.length}');
    return products;
  }
}

