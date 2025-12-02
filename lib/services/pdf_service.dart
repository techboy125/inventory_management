import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../models/product.dart';
import 'package:intl/intl.dart';

class PdfService {
  Future<String> generateInventoryPdf(List<Product> products) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat('#,##0.00', 'en_IN');

    // Calculate totals
    double totalBuyingPrice = 0;
    double totalSellingPrice = 0;
    double totalProfit = 0;

    for (var product in products) {
      totalBuyingPrice += product.buyingPrice;
      totalSellingPrice += product.sellingPrice;
      totalProfit += product.profit;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (context) => [
          // Header
          pw.Center(
            child: pw.Text(
              'INVENTORY REPORT',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              'Generated on ${dateFormat.format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
          pw.SizedBox(height: 20),

          // Summary Section
          pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Summary',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Products: ${products.length}'),
                    pw.Text(
                      'Total Cost: ₹${currencyFormat.format(totalBuyingPrice)}',
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Selling Price: ₹${currencyFormat.format(totalSellingPrice)}',
                    ),
                    pw.Text(
                      'Total Profit: ₹${currencyFormat.format(totalProfit)}',
                      style: pw.TextStyle(
                        color: totalProfit >= 0 ? PdfColors.green : PdfColors.red,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Products organized by category
          ..._buildCategoryProducts(products, currencyFormat),
        ],
      ),
    );

    // Determine a sensible save location:
    // Try to save to external storage (Downloads) if available, 
    // otherwise fall back to application documents
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

    // Create the file
    final fileName = 'Inventory_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${outputDir.path}${Platform.pathSeparator}$fileName');
    
    try {
      await file.writeAsBytes(await pdf.save());
      print('PDF saved successfully to: ${file.path}');

      // Open the saved PDF in the platform default viewer so the user can
      // view/share/save it from there without extra storage permissions.
      try {
        await OpenFile.open(file.path);
      } catch (e) {
        print('Error opening PDF file: $e');
      }

      return file.path;
    } catch (e) {
      print('Error saving PDF: $e');
      rethrow;
    }
  }

  List<pw.Widget> _buildCategoryProducts(
    List<Product> products,
    NumberFormat currencyFormat,
  ) {
    final widgets = <pw.Widget>[];
    
    // Group products by category
    final Map<String, List<Product>> groupedByCategory = {};
    for (var product in products) {
      if (!groupedByCategory.containsKey(product.category)) {
        groupedByCategory[product.category] = [];
      }
      groupedByCategory[product.category]!.add(product);
    }

    // Sort categories by order in wearCategories
    final sortedCategories = groupedByCategory.keys.toList()
      ..sort((a, b) {
        final indexA = wearCategories.indexWhere((c) => c.name == a);
        final indexB = wearCategories.indexWhere((c) => c.name == b);
        return indexA.compareTo(indexB);
      });

    // Build widgets for each category
    for (final category in sortedCategories) {
      final categoryProducts = groupedByCategory[category]!;
      final categoryTotal = categoryProducts.fold<double>(0, (sum, p) => sum + p.profit);

      widgets.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 12),
            pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue100,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '$category (${categoryProducts.length} items)',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Profit: ₹${currencyFormat.format(categoryTotal)}',
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: categoryTotal >= 0 ? PdfColors.green : PdfColors.red,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            // Build product cards with images
            ..._buildProductCards(categoryProducts, currencyFormat),
          ],
        ),
      );
    }

    return widgets;
  }

  List<pw.Widget> _buildProductCards(
    List<Product> products,
    NumberFormat currencyFormat,
  ) {
    return products.map((product) {
      return pw.Container(
        margin: pw.EdgeInsets.only(bottom: 12),
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Product Image
            pw.Container(
              width: 80,
              height: 80,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey200),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: _buildProductImage(product),
            ),
            pw.SizedBox(width: 12),
            // Product Details
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    product.name,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${product.category} > ${product.subcategory}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Material: ${product.material} | Size: ${product.size} | Color: ${product.color}',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Cost: ₹${currencyFormat.format(product.buyingPrice)}',
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                          pw.Text(
                            'Sell: ₹${currencyFormat.format(product.sellingPrice)}',
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Profit: ₹${currencyFormat.format(product.profit)}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: product.profit >= 0 ? PdfColors.green : PdfColors.red,
                            ),
                          ),
                          pw.Text(
                            'Margin: ${product.profitMargin.toStringAsFixed(1)}%',
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  pw.Widget _buildProductImage(Product product) {
    try {
      if (product.imagePath != null && product.imagePath!.isNotEmpty) {
        final imageFile = File(product.imagePath!);
        if (imageFile.existsSync()) {
          return pw.Image(
            pw.MemoryImage(imageFile.readAsBytesSync()),
            fit: pw.BoxFit.cover,
          );
        }
      }
    } catch (e) {
      print('Error loading product image: $e');
    }
    
    // Fallback: placeholder
    return pw.Container(
      color: PdfColors.grey100,
      child: pw.Center(
        child: pw.Text(
          'No Image',
          style: const pw.TextStyle(fontSize: 8),
        ),
      ),
    );
  }
}
