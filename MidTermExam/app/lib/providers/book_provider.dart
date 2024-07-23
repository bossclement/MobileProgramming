import 'package:app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:app/models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookProvider extends ChangeNotifier {
  List<Book> books = [];

  String keyword = '';
  static final DatabaseService _db = DatabaseService.instance;

  List<Book> found = [];
  int sortBy = 0;

  _queryBooks() async {
    List<Book> data = await _db.getBooks() ?? [];
    for (int i = 0; i < data.length; i++) {
      _addBook(data[i]);
    }
  }

  BookProvider() {
    // first get the books from data base
    _queryBooks();
    found = books;
    getSort();
  }

  void _addBook(Book book) {
    books.add(book);
    runFilter(keyword);
    notifyListeners();
  }

  void add(Book book) {
    _addBook(book);
    _db.addBook(book);
  }

  void remove(Book book) {
    books.remove(book);
    if (found.contains(book)) {
      found.remove(book);
    }
    _db.deleteBook(book);
    notifyListeners();
  }

  void edit(Book book) {
    Book found = books.firstWhere((item) => item.id == book.id);
    found.auth = book.auth;
    found.description = book.description;
    found.rating = book.rating;
    found.title = book.title;
    found.image = book.image;
    _db.updateBook(book);
    notifyListeners();
  }

  void runFilter(String enteredKeyword) {
    keyword = enteredKeyword;

    List<Book> results = [];
    found = books;

    // filter keyword
    results = books
          .where((item) => item.title
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()) || item.auth
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase())
            )
          .toList();
    
    // sort
    if (sortBy != 0) {
      switch(sortBy) {
        case 1:
          results.sort((a, b) => double.parse(a.rating).compareTo(double.parse(b.rating)));
          break;
        case 2:
          results.sort((a, b) => b.auth.compareTo(a.auth));
          break;
        case 3:
          results.sort((a, b) => b.title.compareTo(a.title));
          break;
      }
    }
    found = results;
    notifyListeners();
  }

  setSort(int sort) async{
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setInt('sort', sort);
    sortBy = sort;
    runFilter(keyword);
    notifyListeners();
  }

  getSort() async {
    final prefs = await SharedPreferences.getInstance();
    setSort(prefs.getInt('sort') ?? 0);
  }

  setRead(bool value, Book book) {
    book.read = value;
    edit(book);
    notifyListeners();
  }
}