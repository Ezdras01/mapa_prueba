import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/cac_model.dart';

class CsvLoader {
  static Future<List<CAC>> loadCACs() async {
    final rawData = await rootBundle.loadString('assets/cacs_limpios.csv');
    final List<List<dynamic>> csvData = const CsvToListConverter().convert(rawData, eol: '\n');
    
    // Quitar encabezado
    final data = csvData.skip(1).map((row) => CAC.fromList(row)).toList();
    return data;
  }

  static Future<List<String>> getUniqueProducts() async {
    final cacs = await loadCACs();
    final products = cacs.map((e) => e.nombreProducto).toSet().toList();
    products.sort();
    return products;
  }
}
