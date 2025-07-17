// Item type enum will be in item_type.dart
import 'item_type.dart';

class ItemModel {
  final int? id;
  final String title;
  final ItemType type;
  final DateTime date;
  final bool isCompleted;

  ItemModel({
    this.id,
    required this.title,
    required this.type,
    required this.date,
    this.isCompleted = false,
  }) {
    if (title.isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
  }

  ItemModel copyWith({
    int? id,
    String? title,
    ItemType? type,
    DateTime? date,
    bool? isCompleted,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      type: ItemTypeExtension.fromString(map['type'] as String),
      date: DateTime.parse(map['date'] as String),
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }
}
