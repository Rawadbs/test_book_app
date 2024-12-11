import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_book_app/bookdetail.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<dynamic> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final url =
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=العادات');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        books = data['items'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index]['volumeInfo'];
                return ListTile(
                  leading: book['imageLinks'] != null
                      ? Image.network(book['imageLinks']['thumbnail'])
                      : const Icon(Icons.book),
                  title: Text(book['title'] ?? 'No Title'),
                  subtitle:
                      Text(book['authors']?.join(', ') ?? 'Unknown Author'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(
                          title: book['title'] ?? 'No Title',
                          pdfName: getPdfName(book['title'] ?? ''),
                          author:
                              book['authors']?.join(', ') ?? 'Unknown Author',
                          description:
                              book['description'] ?? 'لا يوجد وصف متاح.',
                          category:
                              book['categories']?.join(', ') ?? 'غير مصنف',
                          rating: (book['averageRating'] ?? 0).toDouble(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String getPdfName(String bookTitle) {
    // قم بمقارنة الأسماء هنا
    if (bookTitle == 'العادات الإيجابية') {
      return 'b.pdf';
    } else if (bookTitle == 'العادات الذرية') {
      return 'a.pdf';
    }
    return ''; // ملف افتراضي
  }
}
