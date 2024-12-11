import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Book> books = [];

  Future<void> searchBooks(String query) async {
    final url =
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List items = json.decode(response.body)['items'];
      setState(() {
        books = items.map((item) => Book.fromJson(item)).toList();
      });
    } else {
      throw Exception('فشل تحميل الكتب');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بحث عن الكتب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'ابحث عن كتاب...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                searchBooks(query);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    leading: books[index].imageUrl != null
                        ? Image.network(books[index].imageUrl!)
                        : const Icon(Icons.book),
                    title: Text(books[index].title),
                    subtitle: Text(books[index].authors.join(', ')),
                    onTap: () {
                      _showBookDetails(books[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookDetails(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(book: book),
      ),
    );
  }
}

class Book {
  final String title;
  final List<String> authors;
  final String? imageUrl;
  final String infoLink;
  final String? description;
  final double? rating;
  final List<String> categories;
  final String pdfAssetPath; // مسار الـPDF في الـAssets

  Book({
    required this.title,
    required this.authors,
    this.imageUrl,
    required this.infoLink,
    this.description,
    this.rating,
    required this.categories,
    required this.pdfAssetPath, // تهيئة مسار الـPDF
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'],
      authors: List<String>.from(json['volumeInfo']['authors'] ?? []),
      imageUrl: json['volumeInfo']['imageLinks']?['thumbnail'],
      infoLink: json['volumeInfo']['infoLink'],
      description: json['volumeInfo']['description'],
      rating: json['volumeInfo']['averageRating']?.toDouble(),
      categories: List<String>.from(json['volumeInfo']['categories'] ?? []),
      pdfAssetPath: json['volumeInfo']['title'] == 'العادات الذرية'
          ? 'assets/a.pdf'
          : 'assets/b.pdf', // إضافة مسار الـPDF بناءً على الكتاب
    );
  }
}

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              book.imageUrl != null
                  ? Center(child: Image.network(book.imageUrl!))
                  : const Center(child: Icon(Icons.book, size: 150)),
              const SizedBox(height: 20),
              Text(
                book.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('مؤلف(ون): ${book.authors.join(', ')}'),
              const SizedBox(height: 10),
              if (book.categories.isNotEmpty)
                Text('الفئات: ${book.categories.join(', ')}'),
              const SizedBox(height: 10),
              if (book.rating != null) Text('التقييم: ${book.rating} من 5'),
              const SizedBox(height: 20),
              if (book.description != null)
                const Text(
                  'الوصف:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              if (book.description != null) const SizedBox(height: 10),
              if (book.description != null)
                Text(
                  book.description!,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PDFViewerScreen(pdfAssetPath: book.pdfAssetPath),
                    ),
                  );
                },
                child: const Text('قراءة الكتاب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfAssetPath;

  const PDFViewerScreen({super.key, required this.pdfAssetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: SfPdfViewer.asset(pdfAssetPath), // عرض الـPDF من الـAssets
    );
  }
}
