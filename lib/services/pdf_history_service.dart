import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class PdfFile {
  final String name;
  final String path;
  final DateTime createdAt;
  final int sizeInBytes;

  PdfFile({
    required this.name,
    required this.path,
    required this.createdAt,
    required this.sizeInBytes,
  });

  String get sizeInMB => (sizeInBytes / (1024 * 1024)).toStringAsFixed(2);
  String get formattedDate => DateFormat('dd MMM yyyy, HH:mm').format(createdAt);
}

class PdfHistoryService {
  /// Get all previously generated PDF files
  Future<List<PdfFile>> getAllPdfFiles() async {
    try {
      Directory outputDir;
      
      try {
        if (Platform.isAndroid) {
          final externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            outputDir = externalDir;
          } else {
            outputDir = await getApplicationDocumentsDirectory();
          }
        } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          final dl = await getDownloadsDirectory();
          outputDir = dl ?? await getApplicationDocumentsDirectory();
        } else {
          // iOS and other platforms
          outputDir = await getApplicationDocumentsDirectory();
        }
      } catch (e) {
        print('Error determining save directory: $e');
        outputDir = await getApplicationDocumentsDirectory();
      }

      if (!outputDir.existsSync()) {
        return [];
      }

      // List all PDF files in the directory
      final files = outputDir
          .listSync()
          .where((entity) => entity is File && entity.path.endsWith('.pdf'))
          .cast<File>()
          .toList();

      // Convert to PdfFile objects with metadata
      final pdfFiles = <PdfFile>[];
      for (var file in files) {
        try {
          final stat = file.statSync();
          final name = file.path.split(Platform.pathSeparator).last;
          pdfFiles.add(
            PdfFile(
              name: name,
              path: file.path,
              createdAt: stat.modified,
              sizeInBytes: stat.size,
            ),
          );
        } catch (e) {
          print('Error reading file metadata: $e');
        }
      }

      // Sort by creation date (newest first)
      pdfFiles.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return pdfFiles;
    } catch (e) {
      print('Error getting PDF files: $e');
      return [];
    }
  }

  /// Delete a PDF file
  Future<bool> deletePdfFile(String filePath) async {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting PDF file: $e');
      return false;
    }
  }

  /// Open a PDF file
  Future<void> openPdfFile(String filePath) async {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        // This would need open_file package
        // For now, we'll handle it in the UI layer
      }
    } catch (e) {
      print('Error opening PDF file: $e');
    }
  }

  /// Clear all PDF files
  Future<bool> clearAllPdfs() async {
    try {
      Directory outputDir;
      
      try {
        if (Platform.isAndroid) {
          final externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            outputDir = externalDir;
          } else {
            outputDir = await getApplicationDocumentsDirectory();
          }
        } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          final dl = await getDownloadsDirectory();
          outputDir = dl ?? await getApplicationDocumentsDirectory();
        } else {
          outputDir = await getApplicationDocumentsDirectory();
        }
      } catch (e) {
        print('Error determining save directory: $e');
        outputDir = await getApplicationDocumentsDirectory();
      }

      if (!outputDir.existsSync()) {
        return true;
      }

      final files = outputDir
          .listSync()
          .where((entity) => entity is File && entity.path.endsWith('.pdf'))
          .cast<File>();

      for (var file in files) {
        try {
          await file.delete();
        } catch (e) {
          print('Error deleting file: $e');
        }
      }

      return true;
    } catch (e) {
      print('Error clearing PDFs: $e');
      return false;
    }
  }
}
