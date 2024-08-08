import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  Future<Position?> getCurrentPosition() async {
    Position? position;
    LocationPermission? permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever
        ) {
          return position;
        }
        
      }
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {}
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/gifs/location.json',
              width: 110,
              height: 110,
              fit: BoxFit.fill
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                showDialog(context: context, builder: (context) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                });
                Position? position = await getCurrentPosition();
                if (position != null) {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/map', arguments: {'position': position});
                } else {
                  Navigator.of(context).pop();
                }
                
              }, 
              child: Text(
                'Open Map',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(2)
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
