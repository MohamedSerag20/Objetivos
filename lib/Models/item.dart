import 'package:flutter/material.dart';

enum Priority { urgent, important, medium, regular }

class Item {
  Item({
    required this.name,
    required this.priority,
    required this.details,
    required this.id
  });

  final String name;
  final String priority;
  final String details;
  String id;
  Map<Priority, String> priorityMap = {
    Priority.urgent: "Urgent",
    Priority.important: "Important",
    Priority.medium: "Medium",
    Priority.regular: "Regular"
  };
}
