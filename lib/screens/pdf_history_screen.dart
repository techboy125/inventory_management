import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../services/pdf_history_service.dart';

class PdfHistoryScreen extends StatefulWidget {
  const PdfHistoryScreen({super.key});

  @override
  State<PdfHistoryScreen> createState() => _PdfHistoryScreenState();
}

class _PdfHistoryScreenState extends State<PdfHistoryScreen> {
  late Future<List<PdfFile>> _pdfsFuture;
  final _pdfHistoryService = PdfHistoryService();

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  void _loadPdfs() {
    setState(() {
      _pdfsFuture = _pdfHistoryService.getAllPdfFiles();
    });
  }

  Future<void> _openPdf(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening PDF: ${result.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening PDF: $e')),
      );
    }
  }

  Future<void> _deletePdf(String filePath, String fileName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete PDF'),
        content: Text('Delete "$fileName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _pdfHistoryService.deletePdfFile(filePath);
      if (success) {
        _loadPdfs();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete PDF')),
        );
      }
    }
  }

  Future<void> _clearAllPdfs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All PDFs'),
        content: const Text(
          'Are you sure you want to delete all PDF files? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _pdfHistoryService.clearAllPdfs();
      if (success) {
        _loadPdfs();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All PDFs cleared')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to clear PDFs')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF History'),
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Clear All'),
                onTap: _clearAllPdfs,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<PdfFile>>(
        future: _pdfsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final pdfFiles = snapshot.data ?? [];

          if (pdfFiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No PDFs generated yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generate your first inventory report from the home screen',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: pdfFiles.length,
            itemBuilder: (context, index) {
              final pdfFile = pdfFiles[index];
              return _buildPdfCard(context, pdfFile);
            },
          );
        },
      ),
    );
  }

  Widget _buildPdfCard(BuildContext context, PdfFile pdfFile) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Icon(
            Icons.picture_as_pdf,
            color: Colors.red[700],
            size: 28,
          ),
        ),
        title: Text(
          pdfFile.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              pdfFile.formattedDate,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              'Size: ${pdfFile.sizeInMB} MB',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Open'),
              onTap: () => _openPdf(pdfFile.path),
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              onTap: () => _deletePdf(pdfFile.path, pdfFile.name),
            ),
          ],
        ),
        onTap: () => _openPdf(pdfFile.path),
      ),
    );
  }
}
