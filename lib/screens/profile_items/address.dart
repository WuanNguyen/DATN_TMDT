import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String _selectedOption = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Stateful Dialog'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Option 1'),
            leading: Radio<String>(
              value: 'Option 1',
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Option 2'),
            leading: Radio<String>(
              value: 'Option 2',
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value!;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedOption);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
