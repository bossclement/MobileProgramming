// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  Icon? icon;
  final controller;
  final String hintText;
  final int maxLines;

  Textfield({this.icon, required this.controller, required this.hintText, required this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
        ),
        prefixIcon: this.icon,
        fillColor: Theme.of(context).colorScheme.tertiary,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary
        )
      ),
    );
  }
}