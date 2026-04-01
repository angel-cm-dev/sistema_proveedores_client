import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';

/// Service to generate CSV reports from structured data.
class ReportExportService {
  ReportExportService._();

  /// Generates a CSV string from headers and rows.
  static String toCsv({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(headers.map(_escape).join(','));
    for (final row in rows) {
      buffer.writeln(row.map(_escape).join(','));
    }
    return buffer.toString();
  }

  /// Escapes a CSV field: wraps in quotes if it contains commas, quotes, or newlines.
  static String _escape(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  /// Saves a CSV string to a temporary file and returns its path.
  /// Returns null on web or if saving fails.
  static Future<String?> saveCsvToFile({
    required String csv,
    required String fileName,
  }) async {
    try {
      if (kIsWeb) return null;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(csv);
      AppLogger.info('Report saved: ${file.path}', tag: 'Report');
      return file.path;
    } catch (e, stack) {
      AppLogger.error('Failed to save report', error: e, stack: stack, tag: 'Report');
      return null;
    }
  }
}
