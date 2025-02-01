// Internal Ledger Model
class InternalModel {
  Map<String, dynamic> values = {};
  bool isDebit = true;

  void setValue(String fieldName, dynamic value) {
    values[fieldName] = value;
  }
}