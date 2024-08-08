import 'package:app/provider/appProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  FocusNode _focusNode = FocusNode();
  final TextEditingController lightLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    lightLimitController.text = Provider.of<Appprovider>(context, listen: false).lightLevelLimit.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // light limit
          Text(
            'Light Limit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: lightLimitController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                    ),
                    fillColor: Theme.of(context).colorScheme.tertiary,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary
                    )
                  ),
                  onChanged: (value) {
                    try {
                      Provider.of<Appprovider>(context, listen: false).setLightLevel(int.parse(value));
                    } catch (e) {
                      Provider.of<Appprovider>(context, listen: false).setLightLevel(0);
                    }
                  },
                  onTapOutside: (_) {
                    _focusNode.unfocus();
                  },
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  '   -   ${Provider.of<Appprovider>(context).currentLightLevel}'
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}