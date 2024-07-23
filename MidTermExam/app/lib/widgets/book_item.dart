import 'dart:io';
import 'package:app/models/book.dart';
import 'package:app/pages/routes/book_content.dart';
import 'package:app/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookItem extends StatefulWidget {
  final Book book;
  late final double bottomPadding;

  BookItem({super.key, required this.book, this.bottomPadding = 10});

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  Future<bool> pathExists(String? filePath) async {
    return filePath != null ? await File(filePath).exists() : false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.bottomPadding),
      height: 120,
      color: Colors.black12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          GestureDetector(
            onTap: () async{
              await Navigator.pushNamed(context, '/bookDetails', arguments: {'book': widget.book});
              setState(() {
                widget.book.read = true;
              });
            },
            child: FutureBuilder<bool>(
              future: pathExists(widget.book.image),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 100,
                    padding: EdgeInsets.all(10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData && snapshot.data == true) {
                  return Container(
                    width: 100,
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        image: DecorationImage(
                          image: FileImage(File(widget.book.image!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 100,
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: Center(
                        child: Text(
                          'NO IMAGE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
    
          // title, auth and rate
          Expanded(
            child: Container(
              width: 150,
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async{
                    await Navigator.pushNamed(context, '/bookDetails', arguments: {'book': widget.book});
                    Provider.of<BookProvider>(context, listen: false).setRead(true, widget.book);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // title
                      Text(
                        widget.book.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'By: ${widget.book.auth}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
    
          // action buttons
          Stack(
            children: [
              Container(
                height: double.infinity,
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BookContent(pageTitle: 'Edit book', book: widget.book)));
                      },
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Provider.of<BookProvider>(context, listen: false).setRead(!widget.book.read, widget.book);
                      },
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          widget.book.read == false
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Provider.of<BookProvider>(context, listen: false)
                            .remove(widget.book);
                      },
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber[400],
                      ),
                      Text(
                        widget.book.rating + '/5',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
