import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/item_model.dart';
import '../widgets/item_tile.dart';
import 'add_item_screen.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/item_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<ItemModel>> _todayItemsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadItems();
  }

  void _loadItems() {
    _todayItemsFuture = DatabaseService().getTodayItems(DateTime.now());
  }

  void _refresh() {
    setState(_loadItems);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6DD5FA),
                    Color(0xFF2980B9),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // For symmetry
                  const Text(
                    'Track Bloom',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Material(
                      color: Colors.white24,
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.add, size: 24, color: Colors.white),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddItemScreen()),
                          );
                          _refresh();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              labelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              unselectedLabelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
              tabs: const [
                Tab(child: Text('Today', style: TextStyle(fontSize: 18))),
                Tab(child: Text('Habits', style: TextStyle(fontSize: 18))),
              ],
            ),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Today Tab
                  Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<List<ItemModel>>(
                          future: _todayItemsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: \\${snapshot.error}'));
                            }
                            final items = snapshot.data ?? [];
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              child: items.isEmpty
                                  ? Column(
                                      key: const ValueKey('empty'),
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                                        SizedBox(height: 12),
                                        Text(
                                          'No items for today.',
                                          style: TextStyle(fontSize: 18, color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      key: const ValueKey('list'),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        final item = items[index];
                                        if (item.isCompleted) {
                                          return Dismissible(
                                            key: ValueKey(item.id),
                                            direction: DismissDirection.endToStart,
                                            background: Container(
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              color: Colors.redAccent,
                                              child: const Icon(Icons.delete, color: Colors.white),
                                            ),
                                            confirmDismiss: (_) async {
                                              // Remove from DB and show SnackBar with Undo
                                              final removedItem = item;
                                              // Haptic feedback (mobile only)
                                              if (!kIsWeb && (Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS)) {
                                                HapticFeedback.lightImpact();
                                              }
                                              await DatabaseService().deleteItem(item.id!);
                                              _refresh();
                                              final scaffold = ScaffoldMessenger.of(context);
                                              bool undone = false;
                                              scaffold.clearSnackBars();
                                              scaffold.showSnackBar(
                                                SnackBar(
                                                  content: const Text('Item deleted'),
                                                  action: SnackBarAction(
                                                    label: 'Undo',
                                                    onPressed: () async {
                                                      undone = true;
                                                      await DatabaseService().insertItem(removedItem);
                                                      _refresh();
                                                    },
                                                  ),
                                                  duration: const Duration(seconds: 10),
                                                ),
                                              );
                                              // Wait for SnackBar duration
                                              await Future.delayed(const Duration(seconds: 10));
                                              return !undone;
                                            },
                                            child: ItemTile(
                                              item: item,
                                              onChanged: _refresh,
                                            ),
                                          );
                                        } else {
                                          return ItemTile(
                                            item: item,
                                            onChanged: _refresh,
                                          );
                                        }
                                      },
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Habits Tab (real data)
                  FutureBuilder<List<ItemModel>>(
                    future: _todayItemsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: \\${snapshot.error}'));
                      }
                      final items = (snapshot.data ?? []).where((item) => item.type == ItemType.habit).toList();
                      if (items.isEmpty) {
                        return const Center(child: Text('No habits for today.'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ItemTile(
                            item: item,
                            onChanged: _refresh,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitProgressStub extends StatelessWidget {
  final String label;
  final int count;
  final String emoji;
  final int streak;
  const _HabitProgressStub({
    required this.label,
    required this.count,
    required this.emoji,
    this.streak = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: count.toDouble()),
          duration: const Duration(milliseconds: 700),
          builder: (context, value, child) => Text(
            value.toInt().toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 2),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: streak.toDouble()),
          duration: const Duration(milliseconds: 700),
          builder: (context, value, child) => Text(
            'Streak: ${value.toInt()} days',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
