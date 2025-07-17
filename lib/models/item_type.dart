enum ItemType { task, habit }

extension ItemTypeExtension on ItemType {
  static ItemType fromString(String value) {
    switch (value) {
      case 'task':
        return ItemType.task;
      case 'habit':
        return ItemType.habit;
      default:
        throw ArgumentError('Invalid item type: $value');
    }
  }

  String get name {
    switch (this) {
      case ItemType.task:
        return 'task';
      case ItemType.habit:
        return 'habit';
    }
  }
}
