import 'database_service.dart';
import '../models/progress_model.dart';
import '../models/item_model.dart';

class ProgressRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<ProgressModel> getProgressForItem(int itemId) async {
    // Fetch completion history for the item
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [itemId],
    );
    if (maps.isEmpty) {
      throw Exception('Item not found');
    }
    final item = ItemModel.fromMap(maps.first);
    // For MVP, treat each completion as a single entry in history
    final List<DateTime> completionHistory = [];
    if (item.isCompleted) {
      completionHistory.add(item.date);
    }
    // Calculate streaks and success rate (placeholder logic)
    final int currentStreak = item.isCompleted ? 1 : 0;
    final int longestStreak = item.isCompleted ? 1 : 0;
    final double successRate = item.isCompleted ? 100.0 : 0.0;
    return ProgressModel(
      itemId: itemId,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      successRate: successRate,
      completionHistory: completionHistory,
    );
  }

  // Placeholder for updating streaks and history
  Future<void> updateProgressForItem(
    int itemId,
    bool isCompleted,
    DateTime date,
  ) async {
    // This would update the item's completion and recalculate streaks/history
    // For now, just update the item
    final db = await _dbService.database;
    await db.update(
      'items',
      {'isCompleted': isCompleted ? 1 : 0, 'date': date.toIso8601String()},
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  // Fetch all completed items for analytics
  Future<List<ItemModel>> getCompletedItems() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'isCompleted = 1',
    );
    return maps.map((map) => ItemModel.fromMap(map)).toList();
  }
}
