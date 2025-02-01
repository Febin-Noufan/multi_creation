import 'package:flutter/material.dart';

// Enum to represent field types
enum FieldType {
  text,
  dropdown,
  number,
}

// Model to represent a field configuration
class FieldConfig {
  final String name;
  final int flex;
  final FieldType type;
  final List<String>? dropdownItems;
  final String? prefix;
  final TextInputType? keyboardType;

  const FieldConfig({
    required this.name,
    required this.flex,
    required this.type,
    this.dropdownItems,
    this.prefix,
    this.keyboardType,
  });
}