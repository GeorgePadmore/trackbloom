import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../models/item_type.dart';
import '../services/database_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title = '';
  ItemType _type = ItemType.task;

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final ItemModel newItem = ItemModel(
      title: _title,
      type: _type,
      date: DateTime.now(),
    );
    await DatabaseService().insertItem(newItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a title'
                    : null,
                onSaved: (value) => _title = value!.trim(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ItemType>(
                value: _type,
                items: ItemType.values
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type.name)),
                    )
                    .toList(),
                onChanged: (type) {
                  if (type != null) setState(() => _type = type);
                },
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _saveItem, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
