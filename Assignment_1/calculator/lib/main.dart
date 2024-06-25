import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.bottomRight,
              child: Text(
                '0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildButtonRow(['7', '8', '9', '/']),
          _buildButtonRow(['4', '5', '6', '*']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['0', '.', '=', '+']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((btnText) {
        return CalculatorButton(
          text: btnText,
        );
      }).toList(),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;

  CalculatorButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: SizedBox(
        width: 80,
        height: 80,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: EdgeInsets.all(20),
            backgroundColor: _buttonColor(text),
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {},
          child: Text(
            text,
            style: TextStyle(
              color: _textColor(text),
            ),
          ),
        ),
      ),
    );
  }

  Color _buttonColor(String text) {
    if (text == '0') {
      return Colors.grey[700]!;
    } else if (text == '=') {
      return Colors.orange[700]!;
    } else if (['/', '*', '-', '+'].contains(text)) {
      return Colors.orange[400]!;
    } else {
      return Colors.grey[800]!;
    }
  }

  Color _textColor(String text) {
    if (['/', '*', '-', '+', '='].contains(text)) {
      return Colors.white;
    } else {
      return Colors.white70;
    }
  }
}
