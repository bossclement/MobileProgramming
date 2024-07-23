import 'package:app/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyBottomsheet extends StatefulWidget {

  @override
  State<MyBottomsheet> createState() => _MyBottomsheetState();
}

class _MyBottomsheetState extends State<MyBottomsheet> {
  List<String> options = [
    'Default',
    'Rating',
    'Author',
    'Title'
  ];

  void _onRadioClicked(value) {
    setState(() {
      Provider.of<BookProvider>(context, listen: false).setSort(value!);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 10, right: 10),
      child: Column(
        children: [
          // title and close botton
          Container(
            height: 30,
            width: double.infinity,
            child: Center(
              child: Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          // options
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1
                      )
                    )
                  ),
                  child: ListTile(
                    onTap: () => _onRadioClicked(index == Provider.of<BookProvider>(context, listen: false).sortBy ? -1 : index),
                    leading: Radio(
                      value: index == Provider.of<BookProvider>(context, listen: false).sortBy ? -1 : index,
                      groupValue: -1,
                      onChanged: (value) => _onRadioClicked(value),
                    ),
                    title: Text(
                      options[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}