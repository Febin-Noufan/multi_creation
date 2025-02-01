

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
