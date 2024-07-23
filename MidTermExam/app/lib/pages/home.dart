import 'package:app/providers/book_provider.dart';
import 'package:app/widgets/book_item.dart';
import 'package:app/widgets/bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FocusNode _focusNode;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search box
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: searchBox(),
        ),

        // filter
        Container(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(context: context, builder: (context) => MyBottomsheet());
            },
            child: Transform(
              transform: Matrix4.translationValues(MediaQuery.of(context).size.width * 0.77, 0, 0),
              child: ListTile(
                leading: Icon(
                  Icons.account_tree_sharp,
                  size: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-18, 0, 0),
                  child: Text(
                    'Sort',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                )
              ),
            ),
          ),
        ),
        
        // title
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(bottom: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'List of books',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
    
        // list of books
        searchController.text.isEmpty == false || Provider.of<BookProvider>(context).sortBy != 0 ?
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: Provider.of<BookProvider>(context).found.length,
              itemBuilder: (context, index) {
                return BookItem(book: Provider.of<BookProvider>(context).found.reversed.elementAt(index),
                  bottomPadding: index != Provider.of<BookProvider>(context).found.length - 1 ? 10 : 80,);
              },
            ),
          ),
        ) : Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: Provider.of<BookProvider>(context).books.length,
              itemBuilder: (context, index) {
                return BookItem(book: Provider.of<BookProvider>(context).books.reversed.elementAt(index),
                  bottomPadding: index != Provider.of<BookProvider>(context).books.length - 1 ? 10 : 80,);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => Provider.of<BookProvider>(context, listen: false).runFilter(value),
        focusNode: _focusNode,
        onTapOutside: (_) {
          _focusNode.unfocus();
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}