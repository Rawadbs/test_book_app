import 'package:flutter/material.dart';
import 'package:test_book_app/booklistpage.dart';
import 'package:test_book_app/bookpage.dart';

void main() {
  runApp(const BookReaderApp());
}

class BookReaderApp extends StatelessWidget {
  const BookReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Reader App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookSearchScreen(),
    );
  }
}
