import 'dart:io';
import 'package:app/models/book.dart';
import 'package:flutter/material.dart';

class BookDetails extends StatefulWidget {
  final Book book;

  BookDetails({required this.book});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  Future<bool> pathExists(String? filePath) async {
    return filePath != null && !filePath.isEmpty ? await File(filePath).exists() : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Details',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // book image
              FutureBuilder(
                future: pathExists(widget.book.image),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data == true ?
                    SizedBox(
                      width: 100,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: FileImage(File(widget.book.image!)),
                            fit: BoxFit.cover
                          )
                        ),
                      )
                    ) : SizedBox(
                      width: 100,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        child: Center(
                          child: Text(
                            'NO IMAGE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: 100,
                      padding: EdgeInsets.all(10),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
              
              SizedBox(height: 20),

            
              // title
              Text(
                widget.book.title,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 15),
            
              // description
            
              Text(
                widget.book.description,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 15),
            
              // author
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'By: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ),
                    TextSpan(
                      text: widget.book.auth,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    )
                  ]
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}