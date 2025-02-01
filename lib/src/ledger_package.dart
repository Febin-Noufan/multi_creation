import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_creation/multi_creation.dart';
import 'package:multi_creation/src/models/internal_ledger_model.dart';



// Main Ledger Widget
class MulipleCreationWidget extends StatefulWidget {
  final List<FieldConfig> fieldConfigs;
  final Function(List<Map<String, dynamic>>) onSave; // Return List<Map>
  final Widget? header;
  final Widget? footer;

  const MulipleCreationWidget({
    super.key,
    required this.fieldConfigs,
    required this.onSave,
    this.header,
    this.footer,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MulipleCreationWidgettState createState() => _MulipleCreationWidgettState();
}

class _MulipleCreationWidgettState extends State<MulipleCreationWidget> {
  final List<InternalModel> _ledgers = [];
  final List<List<FocusNode>> _focusNodes = [];
  int _currentIndex = 0;
  int _currentField = 0;

  @override
  void initState() {
    super.initState();
    _addNewLedger();
    ServicesBinding.instance.keyboard.addHandler(_handleKeyboardShortcuts);
  }

  bool _handleKeyboardShortcuts(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyS &&
          HardwareKeyboard.instance.isAltPressed) {
        _saveLedgers();
        return true;
      }
    }
    return false;
  }

  void _saveLedgers() {
     bool isValid = _ledgers.every((ledger) {
      return widget.fieldConfigs.every((config) {
        if (config.type == FieldType.dropdown &&
            config.name != 'type') {
          return ledger.values[config.name] != null;
        } else if (config.type != FieldType.dropdown) {
          return ledger.values[config.name]?.isNotEmpty == true;
        }
        return true;
      });
    });


    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


      final List<Map<String, dynamic>> result = _ledgers.map((ledger) => ledger.values).toList();
    widget.onSave(result);
       // Clear the existing data and add an empty row after save
       _clearData();
  }

   void _clearData() {
    setState(() {
        _ledgers.clear();
       _focusNodes.clear();
      _currentIndex=0;
      _currentField=0;

      _addNewLedger(); // Add a new, empty row
    });
  }

  

     void handleKeyPress(RawKeyEvent event) {
      if (event is RawKeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.tab) {
          _moveToNextField(fromKeyboard: true);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          _moveDown();
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          _moveUp();
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _moveLeft();
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _moveRight();
        }
      }
    }

        void _moveLeft() {
      if (_currentField > 0) {
        setState(() {
          _currentField--;
          _focusNodes[_currentIndex][_currentField].requestFocus();
        });
      }
    }

    void _moveRight() {
       if (_currentField < widget.fieldConfigs.length - 1) {
        setState(() {
          _currentField++;
          _focusNodes[_currentIndex][_currentField].requestFocus();
        });
      }
    }

    
   void _moveToNextField({bool fromKeyboard = false}) {
    setState(() {
         if (fromKeyboard) {
            bool allRequiredFilled = true;
            // Check if the current row's required fields are filled
            if (_ledgers.isNotEmpty) {
              final currentRow = _ledgers[_currentIndex];
               allRequiredFilled = widget.fieldConfigs.every((config) {
                if (config.type == FieldType.dropdown &&
                  config.name != 'type') {
                  return currentRow.values[config.name] != null;
                } else if (config.type != FieldType.dropdown) {
                   return currentRow.values[config.name]?.isNotEmpty == true;
                 }
                 return true;
               });

            }

             if (_currentField >= widget.fieldConfigs.length - 1) {
                  _currentField = 0;
                 if (_currentIndex == _ledgers.length - 1 && allRequiredFilled) {
                   _addNewLedger();
                 }
                _unfocusRowFields(_currentIndex);
                if(allRequiredFilled){
                _currentIndex++;
                }
                } else {
               _currentField++;
             }
          }


      if (_currentIndex < _focusNodes.length &&
          _currentField < _focusNodes[_currentIndex].length) {
        _focusNodes[_currentIndex][_currentField].requestFocus();
      }
    });
  }

  void _addNewLedger() {
    setState(() {
      _ledgers.add(InternalModel());
      _focusNodes.add(
        List.generate(widget.fieldConfigs.length, (index) => FocusNode()),
      );
    });
  }

  void _unfocusRowFields(int rowIndex) {
    if (rowIndex >= 0 && rowIndex < _focusNodes.length) {
      for (var node in _focusNodes[rowIndex]) {
        node.unfocus();
      }
    }
  }

  void _moveDown() {
      if (_currentIndex < _ledgers.length - 1) {
        setState(() {
          _currentIndex++;
          _focusNodes[_currentIndex][_currentField].requestFocus();
        });
      }
        else {
          if(_ledgers.isNotEmpty)
         {
           bool allRequiredFilled = true;
             final currentRow = _ledgers[_currentIndex];
             allRequiredFilled = widget.fieldConfigs.every((config) {
               if (config.type == FieldType.dropdown &&
                   config.name != 'type') {
                 return currentRow.values[config.name] != null;
               } else if (config.type != FieldType.dropdown) {
                  return currentRow.values[config.name]?.isNotEmpty == true;
               }
               return true;
             });

           if(allRequiredFilled){
             _addNewLedger();
              setState(() {
                _currentIndex++;
                _focusNodes[_currentIndex][_currentField].requestFocus();
              });

           }
         }
        }
    }


    void _moveUp() {
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
          _focusNodes[_currentIndex][_currentField].requestFocus();
        });
      }
    }

    Widget _buildField(FieldConfig config, int rowIndex, int fieldIndex) {
    switch (config.type) {
      case FieldType.text:
        return TextField(
          controller: TextEditingController(
            text: _ledgers[rowIndex].values[config.name]?.toString() ?? '', // Set initial value from model
          ),
          focusNode: _focusNodes[rowIndex][fieldIndex],
          autofocus: rowIndex == 0 && fieldIndex == 0,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _ledgers[rowIndex].setValue(config.name, value);
          },
        );

       case FieldType.dropdown:
         return DropdownButtonFormField<String>(
            focusNode: _focusNodes[rowIndex][fieldIndex],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
           value: _ledgers[rowIndex].values[config.name]?.toString(),
           items: config.dropdownItems?.map((String item) {
             return DropdownMenuItem<String>(
               value: item,
               child: Text(item == 'Debit'
                   ? 'Dr'
                   : item == 'Credit'
                       ? 'Cr'
                       : item),
             );
           }).toList(),
            onChanged: (value) {
              setState(() {
                _ledgers[rowIndex].setValue(config.name, value);
                if (config.name == 'type') {
                    _ledgers[rowIndex].isDebit = value == 'Debit';
                  }
              });
             _moveToNextField();
           },
         );


      case FieldType.number:
        return TextField(
           controller: TextEditingController(
            text: _ledgers[rowIndex].values[config.name]?.toString() ?? '', // Set initial value from model
          ),
          focusNode: _focusNodes[rowIndex][fieldIndex],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            prefixText: config.prefix,
          ),
          keyboardType: config.keyboardType,
          onChanged: (value) {
            _ledgers[rowIndex].setValue(config.name, value);
          },
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: handleKeyPress,
      child: Column(
        children: [
          widget.header ??
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Row(
                  children: widget.fieldConfigs
                      .map((config) => Expanded(
                            flex: config.flex,
                            child: Text(config.name.toUpperCase()),
                          ))
                      .toList(),
                ),
              ),
          Expanded(
            child: ListView.builder(
              itemCount: _ledgers.length,
              itemBuilder: (context, rowIndex) {
                return Container(
                  color: _currentIndex == rowIndex ? Colors.blue[50] : null,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: List.generate(
                      widget.fieldConfigs.length,
                      (fieldIndex) => Expanded(
                        flex: widget.fieldConfigs[fieldIndex].flex,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildField(
                            widget.fieldConfigs[fieldIndex],
                            rowIndex,
                            fieldIndex,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          widget.footer ??
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    const Text('Total Ledgers: '),
                    Text(_ledgers.length.toString()),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _saveLedgers,
                      child: const Text('Save (Alt + S)'),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var list in _focusNodes) {
      for (var node in list) {
        node.dispose();
      }
    }
    ServicesBinding.instance.keyboard.removeHandler(_handleKeyboardShortcuts);
    super.dispose();
  }
}