import 'dart:io';
import 'package:app/models/book.dart';
import 'package:app/providers/book_provider.dart';
import 'package:app/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BookContent extends StatefulWidget {
  final String pageTitle;
  final Book? book;

  BookContent({super.key, required this.pageTitle, this.book});

  @override
  State<BookContent> createState() => _BookContentState(book);
}

class _BookContentState extends State<BookContent> {
  Book? book;

  _BookContentState(Book? book) {
    this.book = book;
  }
  
  String? _selected_image;
  TextEditingController titleContoller = TextEditingController();
  TextEditingController authContoller = TextEditingController();
  TextEditingController descContoller = TextEditingController();
  double _rating = 0.0;

  Future selectImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selected_image = image?.path;
    });
  }

  @override
  void initState() {
    super.initState();
     if (book != null) {
      _selected_image = book!.image;
      authContoller.text = book!.auth;
      descContoller.text = book!.description;
      titleContoller.text = book!.title;
      _rating = double.parse(book!.rating);
     }
  }

  Future<bool> pathExists(String? filePath) async {
    return filePath != null && !filePath.isEmpty ? await File(filePath).exists() : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pageTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: Column(
              children: [
                // image
                Stack(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 120,
                      child: Container(
                        color: Colors.grey[100],
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    color: Colors.grey[400]
                                  ),
                                )
                              ],
                            ),
                          ]
                        )
                      )
                    ),
                    FutureBuilder(
                      future: pathExists(_selected_image),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == true) {
                            return GestureDetector(
                              onTap: () {
                                selectImage();
                              },
                              child: SizedBox(
                                width: 100,
                                height: 120,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: FileImage(File(_selected_image!)),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                )
                              ),
                            );
                          }
                        }
                        return GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: SizedBox(
                            width: 100,
                            height: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                            )
                          ),
                        );
                      },
                    ),
                    
                  ]
                ),
                SizedBox(height: 20),

                // rating
                Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),

                RatingBar.builder(
                  allowHalfRating: true,
                  glow: false,
                  initialRating: _rating,
                  unratedColor: Colors.grey[400],
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    _rating = value;
                  },
                ),
                  
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Column(
                    children: [
                      // book title
                      Textfield(controller: titleContoller, hintText: 'Book Title', maxLines: 1),
                      SizedBox(height: 20),
                        
                      // book author
                      Textfield(controller: authContoller, hintText: 'Book Author', maxLines: 1),
                      SizedBox(height: 20),
        
                      // book description
                      Textfield(controller: descContoller, hintText: 'Description', maxLines: 5),
                      SizedBox(height: 30),
                        
                      // save and cancel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (titleContoller.text.isEmpty || authContoller.text.isEmpty || descContoller.text.isEmpty) {
                                return;
                              }
                              Book book;
                              if (this.book == null) {
                                book = Book(
                                auth: authContoller.text,
                                rating: _rating.toString(),
                                title: titleContoller.text,
                                description: descContoller.text,
                                id: DateTime.now().microsecondsSinceEpoch.toString(),
                                read: false,
                                image: _selected_image
                                );
                                Provider.of<BookProvider>(context, listen: false).add(book);
                              } else {
                                book = this.book!;
                                book.image = _selected_image;
                                book.title = titleContoller.text;
                                book.auth = authContoller.text;
                                book.description = descContoller.text;
                                book.rating = _rating.toString();
                                Provider.of<BookProvider>(context, listen: false).edit(book);
                              }
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              minimumSize: Size(120, 40)
                            ),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                              ),
                              minimumSize: Size(120, 40)
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}