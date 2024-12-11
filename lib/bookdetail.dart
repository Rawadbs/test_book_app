import 'package:flutter/material.dart';
import 'package:test_book_app/bookpdfviewerpage.dart';

class BookDetailsPage extends StatelessWidget {
  final String title;
  final String pdfName;
  final String author;
  final String description;
  final String category;
  final double rating;

  BookDetailsPage({
    required this.title,
    required this.pdfName,
    required this.author,
    required this.description,
    required this.category,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المؤلف: $author',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'التصنيف: $category',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'التقييم: ${rating.toStringAsFixed(1)} ⭐',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'الوصف:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewPage(pdfName: pdfName),
                    ),
                  );
                },
                child: Text('عرض الكتاب'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
