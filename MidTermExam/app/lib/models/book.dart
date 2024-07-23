

class Book {
  String auth;
  String rating;
  String title;
  String description;
  String id;
  bool read;
  String? image;

  Book({required this.auth, required this.rating, required this.title, required this.description,
        required this.id, required this.read, this.image});

}