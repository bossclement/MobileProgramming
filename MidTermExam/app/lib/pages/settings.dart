import 'package:app/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        children: [
          // theme toggle
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                  value: Provider.of<ThemeProvider>(context).light,
                  onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(!Provider.of<ThemeProvider>(context, listen: false).light),
                ),
                SizedBox(width: 10),
                Text(
                  'Light mode',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}