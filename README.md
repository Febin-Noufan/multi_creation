

A reusable Flutter package for creating multiple ledger entries with keyboard navigation.

## Features

- Configuration-driven UI using `FieldConfig`.
- Keyboard navigation using Enter/Tab and arrow keys.
- Manages the data internally.
- Customizable header and footer.
- Returns saved data as a List<Map<String, dynamic>>.

## Usage

Import the package:

```dart
import 'package:my_ledger_package/ledger_package.dart';

----------------------------------------------------------------------------------------------------------------------------------------

Usage
>>>>>>>>>>>>>>>>>>>>>>>>


TallyLedgerWidget(
  fieldConfigs: [
    FieldConfig(name: 'name', flex: 2, type: FieldType.text),
    FieldConfig(
      name: 'group',
      flex: 2,
      type: FieldType.dropdown,
      dropdownItems: ['Assets', 'Liabilities'],
    ),
    // ... other field configurations
  ],
  onSave: (ledgers) {
    // Handle saved data
  },
);


Example 

>>>>>>>>>>>>>>>>>>>>>>>>>



import 'package:flutter/material.dart';
import 'package:list_test/ledger.dart';

import 'package:multi_creation/multi_creation.dart';

class MyLedgerPage extends StatefulWidget {
  const MyLedgerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyLedgerPageState createState() => _MyLedgerPageState();
}

class _MyLedgerPageState extends State<MyLedgerPage> {
  List<Map<String, dynamic>> _savedLedgerData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Multiple Ledger Creation'),
          backgroundColor: Colors.grey),
      body: MulipleCreationWidget(
        fieldConfigs: [
          FieldConfig(
            name: 'name',
            flex: 2,
            type: FieldType.text,
          ),
          FieldConfig(
            name: 'group',
            flex: 2,
            type: FieldType.dropdown,
            dropdownItems: ['Assets', 'Liabilities'],
          ),
          FieldConfig(
            name: 'type',
            flex: 1,
            type: FieldType.dropdown,
            dropdownItems: ['Debit', 'Credit'],
          ),
          FieldConfig(
            name: 'amount',
            flex: 2,
            type: FieldType.number,
            keyboardType: TextInputType.number,
            prefix: '\$',
          ),
          FieldConfig(
            name: 'Descount',
            flex: 2,
            type: FieldType.number,
            keyboardType: TextInputType.number,
            prefix: '\$',
          ),
        ],
        header: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    "NAME".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    "Group".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    "TYPE".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    "AMOUNT".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  flex: 2,
                  child: Text(
                    "Descount".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
        footer: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Row(
            children: [
              const Text('Total Ledgers: '),
              const Text("0"),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Saved Ledger Data: $_savedLedgerData');
          
                },
                child: const Text(
                  'Save (Alt + S)',
                ),
              ),
            ],
          ),
        ),
        onSave: (ledgers) {
          setState(() {
            _savedLedgerData = ledgers;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LedgerListPage(ledgers: _savedLedgerData)));
          });
        },
      ),
    );
  }
}
