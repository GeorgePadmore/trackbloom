import 'package:flutter/material.dart';
import '../services/progress_repository.dart';
import '../models/progress_model.dart';
import '../models/item_model.dart';
import '../services/database_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _filter = 'all'; // all, completed, active
  String _sort = 'streak'; // streak, name, success
  bool _groupByStatus = false;

  Future<List<_HabitProgressData>> _fetchAllHabitsProgress() async {
    final db = DatabaseService();
    final List<ItemModel> allItems = await db.getTodayItems(DateTime.now());
    final habits = allItems.where((item) => item.type.name == 'habit').toList();
    final repo = ProgressRepository();
    final List<_HabitProgressData> result = [];
    for (final habit in habits) {
      final progress = await repo.getProgressForItem(habit.id!);
      result.add(_HabitProgressData(habit: habit, progress: progress));
    }
    return result;
  }

  List<_HabitProgressData> _applyFilterSortGroup(
    List<_HabitProgressData> data,
  ) {
    // Filtering
    List<_HabitProgressData> filtered = switch (_filter) {
      'completed' => data.where((d) => d.habit.isCompleted).toList(),
      'active' => data.where((d) => !d.habit.isCompleted).toList(),
      _ => data,
    };
    // Sorting
    switch (_sort) {
      case 'name':
        filtered.sort((a, b) => a.habit.title.compareTo(b.habit.title));
        break;
      case 'success':
        filtered.sort(
          (b, a) => a.progress.successRate.compareTo(b.progress.successRate),
        );
        break;
      case 'streak':
      default:
        filtered.sort(
          (b, a) =>
              a.progress.currentStreak.compareTo(b.progress.currentStreak),
        );
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF181A20)
            : const Color(0xFFF5F6FA),
        child: Column(
          children: [
            const _ProgressHeader(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Filter dropdown
                  Expanded(
                    child: DropdownButton<String>(
                      value: _filter,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text('Completed'),
                        ),
                        DropdownMenuItem(
                          value: 'active',
                          child: Text('Active'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _filter = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Sort dropdown
                  Expanded(
                    child: DropdownButton<String>(
                      value: _sort,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'streak',
                          child: Text('Streak'),
                        ),
                        DropdownMenuItem(value: 'name', child: Text('Name')),
                        DropdownMenuItem(
                          value: 'success',
                          child: Text('Success Rate'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _sort = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Group by status
                  Flexible(
                    child: Row(
                      children: [
                        Checkbox(
                          value: _groupByStatus,
                          onChanged: (val) =>
                              setState(() => _groupByStatus = val ?? false),
                        ),
                        const Flexible(
                          child: Text(
                            'Group by Status',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<_HabitProgressData>>(
                future: _fetchAllHabitsProgress(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No habits tracked yet.'));
                  }
                  final habitProgressList = _applyFilterSortGroup(
                    snapshot.data!,
                  );
                  if (_groupByStatus) {
                    final completed = habitProgressList
                        .where((d) => d.habit.isCompleted)
                        .toList();
                    final active = habitProgressList
                        .where((d) => !d.habit.isCompleted)
                        .toList();
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      children: [
                        if (active.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...active.map(
                            (data) => _HabitProgressCard(
                              title: data.habit.title,
                              currentStreak: data.progress.currentStreak,
                              longestStreak: data.progress.longestStreak,
                              successRate: data.progress.successRate,
                            ),
                          ),
                        ],
                        if (completed.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...completed.map(
                            (data) => _HabitProgressCard(
                              title: data.habit.title,
                              currentStreak: data.progress.currentStreak,
                              longestStreak: data.progress.longestStreak,
                              successRate: data.progress.successRate,
                            ),
                          ),
                        ],
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: habitProgressList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final data = habitProgressList[index];
                      return _HabitProgressCard(
                        title: data.habit.title,
                        currentStreak: data.progress.currentStreak,
                        longestStreak: data.progress.longestStreak,
                        successRate: data.progress.successRate,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitProgressData {
  final ItemModel habit;
  final ProgressModel progress;
  _HabitProgressData({required this.habit, required this.progress});
}

class _HabitProgressCard extends StatelessWidget {
  final String title;
  final int currentStreak;
  final int longestStreak;
  final double successRate;
  const _HabitProgressCard({
    required this.title,
    required this.currentStreak,
    required this.longestStreak,
    required this.successRate,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StreakStat(
                  title: 'Current Streak',
                  value: currentStreak.toString(),
                ),
                _StreakStat(
                  title: 'Longest Streak',
                  value: longestStreak.toString(),
                ),
                _StreakStat(
                  title: 'Success Rate',
                  value: '${successRate.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Progress',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakAnalyticsSection extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final double successRate;
  const _StreakAnalyticsSection({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.successRate = 0.0,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StreakStat(
              title: 'Current Streak',
              value: currentStreak.toString(),
            ),
            _StreakStat(
              title: 'Longest Streak',
              value: longestStreak.toString(),
            ),
            _StreakStat(
              title: 'Success Rate',
              value: '${successRate.toStringAsFixed(1)}%',
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String title;
  final String value;
  const _StreakStat({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _WeeklyHeatmapSection extends StatelessWidget {
  const _WeeklyHeatmapSection();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'Weekly Heatmap (Placeholder)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _MonthlySummarySection extends StatelessWidget {
  const _MonthlySummarySection();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'Monthly Summary (Placeholder)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _AchievementBadgesSection extends StatelessWidget {
  const _AchievementBadgesSection();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'Achievement Badges (Placeholder)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _HabitHistorySection extends StatelessWidget {
  const _HabitHistorySection();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text('Habit 2${index + 1}'),
          subtitle: const Text('Completed on 2024-06-01'),
        ),
      ),
    );
  }
}
