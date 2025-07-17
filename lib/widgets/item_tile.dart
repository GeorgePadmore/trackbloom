import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/database_service.dart';

class ItemTile extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onChanged;

  const ItemTile({Key? key, required this.item, required this.onChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      leading: Checkbox(
        value: item.isCompleted,
        onChanged: (_) async {
          final updated = item.copyWith(isCompleted: !item.isCompleted);
          await DatabaseService().updateItem(updated);
          onChanged();
        },
      ),
      title: Text(
        item.title,
        style: TextStyle(
          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        item.type.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: item.isCompleted
          ? SizedBox(
              width: 24,
              child: const Icon(
                Icons.swipe_left,
                color: Colors.redAccent,
                size: 20,
              ),
            )
          : null,
    );
    return tile;
  }
}
