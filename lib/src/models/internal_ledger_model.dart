class InternalModel {
  Map<String, dynamic> values = {};
  bool isDebit = true;
  bool isEdited = false;

  void setValue(String fieldName, dynamic value) {
    values[fieldName] = value;
    isEdited = true;
  }

  bool get isEmpty => values.values.every((value) => value == null || value == '');
}
