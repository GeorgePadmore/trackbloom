// import 'package:flutter/foundation.dart';

class ProgressModel {
  final int itemId;
  final int currentStreak;
  final int longestStreak;
  final double successRate;
  final List<DateTime> completionHistory;

  ProgressModel({
    required this.itemId,
    required this.currentStreak,
    required this.longestStreak,
    required this.successRate,
    required this.completionHistory,
  }) {
    if (itemId < 0) {
      throw ArgumentError('itemId must be positive');
    }
    if (currentStreak < 0 || longestStreak < 0) {
      throw ArgumentError('Streaks must be non-negative');
    }
    if (successRate < 0 || successRate > 100) {
      throw ArgumentError('Success rate must be between 0 and 100');
    }
  }

  ProgressModel copyWith({
    int? itemId,
    int? currentStreak,
    int? longestStreak,
    double? successRate,
    List<DateTime>? completionHistory,
  }) {
    return ProgressModel(
      itemId: itemId ?? this.itemId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      successRate: successRate ?? this.successRate,
      completionHistory: completionHistory ?? this.completionHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'successRate': successRate,
      'completionHistory': completionHistory
          .map((d) => d.toIso8601String())
          .toList(),
    };
  }

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      itemId: map['itemId'] as int,
      currentStreak: map['currentStreak'] as int,
      longestStreak: map['longestStreak'] as int,
      successRate: (map['successRate'] as num).toDouble(),
      completionHistory: List<String>.from(
        map['completionHistory'] as List,
      ).map((d) => DateTime.parse(d)).toList(),
    );
  }
}
