import 'package:app/models/book.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final _bookTableName = 'books';
  final _bookIdColumnName = 'id';
  final _bookAuthColumnName = 'auth';
  final _bookRatingColumnName = 'rating';
  final _bookTitleColumnName = 'title';
  final _bookDescColumnName = 'desc';
  final _bookReadColumnName = 'read';
  final _bookImageColumnName = 'image';


  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'book_db.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) => db.execute(
        '''
        CREATE TABLE $_bookTableName (
          $_bookIdColumnName TEXT PRIMARY KEY,
          $_bookAuthColumnName TEXT NOT NULL,
          $_bookRatingColumnName TEXT NOT NULL,
          $_bookTitleColumnName TEXT NOT NULL,
          $_bookDescColumnName TEXT NOT NULL,
          $_bookReadColumnName INTEGER NOT NULL,
          $_bookImageColumnName TEXT NOT NULL
        )
      '''),
    );
    return database;
  }

  void addBook(Book book) async {
    final db = await database;
    await db.insert(_bookTableName,
      {
        _bookIdColumnName: book.id,
        _bookAuthColumnName: book.auth,
        _bookRatingColumnName: book.rating,
        _bookTitleColumnName: book.title,
        _bookDescColumnName: book.description,
        _bookReadColumnName: book.read ? 1 : 0,
        _bookImageColumnName: book.image ?? ''
      }
    );
  }

  Future<List<Book>?> getBooks() async {
    final db = await database;
    final data = await db.query(_bookTableName);
    List<Book>? books = data.map((e) => Book(
      auth: e['auth'] as String,
      rating: e['rating'] as String,
      title: e['title'] as String,
      description: e['desc'] as String,
      id: e['id'] as String,
      read: e['read'] as int == 1 ? true : false,
      image: e['image'] as String
    )).toList();
    return books;
  }

  void updateBook(Book book) async {
    final db = await database;
    await db.update(
      _bookTableName,
      {
        _bookAuthColumnName: book.auth,
        _bookRatingColumnName: book.rating,
        _bookTitleColumnName: book.title,
        _bookDescColumnName: book.description,
        _bookReadColumnName: book.read ? 1 : 0,
        _bookImageColumnName: book.image ?? '',
      },
      where: 'id = ?',
      whereArgs: [
        book.id
      ]
    );
  }

  void deleteBook(Book book) async {
    final db = await database;
    await db.delete(
      _bookTableName,
      where: 'id = ?',
      whereArgs: [
        book.id
      ]
    );
  }
}