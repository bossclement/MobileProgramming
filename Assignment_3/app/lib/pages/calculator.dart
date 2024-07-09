import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);
  
  @override
  State<CalculatorScreen> createState() => CalculatorState();
}

class CalculatorState extends State<CalculatorScreen> {
  String? text;

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) {
        return MyButton(text: text);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: double.infinity,
                height: 120,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(bottom: 20, right: 20),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Text(
                  '0',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 50,
                  ),
                ),
              ),
              Column(
                children: [
                  _buildButtonRow(['AC', '+/-', '%', '/']),
                  _buildButtonRow(['7', '8', '9', '*']),
                  _buildButtonRow(['4', '5', '6', '-']),
                  _buildButtonRow(['1', '2', '3', '+']),
                  _buildButtonRow(['0', '.', '=']),
                ],
              ),
            ],
          ),
        )
      );
  }
}

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  late  String text;

  MyButton({required this.text});

  @override
  Widget build(BuildContext context) {
    var btn = Container(
      margin: EdgeInsets.all(8),
      child: SizedBox(
          height: 75,
          width: 75,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
              ),
              backgroundColor: _buttonColor()
            ),
            child: Text(
              text,
              style: TextStyle(
                color: _textColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            
            
          ),
      ),
    );

    if (text != '0')
      return btn;
    return Expanded(
      child: btn,
    );
  }

  Color _buttonColor() {
    if (['/', '*', '-', '+', '='].contains(text)) {
      return Colors.orange[400]!;
    } else if (['AC', '+/-', '%'].contains(text)) {
      return Colors.grey.shade300;
    }
    return Colors.grey.shade900;
  }

  Color _textColor() {
    if (['/', '*', '-', '+', '='].contains(text)) {
      return Colors.white;
    } else if (['AC', '+/-', '%'].contains(text)) {
      return Colors.black;
    }
    return Colors.white;
  }
}