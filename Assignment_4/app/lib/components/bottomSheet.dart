import 'package:flutter/material.dart';


// ignore: must_be_immutable
class MyBottomSheet extends StatelessWidget {

  Future Function() gallery;
  Future Function() photo;

  MyBottomSheet({required this.gallery, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Option'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  photo();
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera,
                        size: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Take a photo',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 60),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  gallery();
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_album,
                        size: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Select a photo',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}