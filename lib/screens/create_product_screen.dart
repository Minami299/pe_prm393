import 'package:flutter/material.dart';
import 'package:pe/models/product.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _parseDate(String input) {
    try {
      final trimmed = input.trim();
      final parts = trimmed.split(RegExp(r'[-/]'));
      if (parts.length == 3) {
        if (parts[0].length == 4) {
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        } else if (parts[2].length == 4) {
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      }
      return DateTime.tryParse(trimmed);
    } catch (_) {
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final initial = _parseDate(_dateController.text) ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        productId: _idController.text.trim(),
        productName: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        manufactureDate: _parseDate(_dateController.text.trim())!,
      );

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Product Created'),
            content: Text(
              'ProductID: ${product.productId}\n'
              'ProductName: ${product.productName}\n'
              'Price: ${product.price}\n'
              'ManufactureDate: ${_dateController.text.trim()}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _cancelForm() {
    _formKey.currentState?.reset();
    _idController.clear();
    _nameController.clear();
    _priceController.clear();
    _dateController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product create by [Mã sinh viên – Tên SV]'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('productIdField'),
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ProductID',
                  hintText: 'Enter product ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ProductID is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('productNameField'),
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ProductName',
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ProductName is required';
                  }
                  if (value.trim().length < 3) {
                    return 'ProductName must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('priceField'),
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price (> 0)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }
                  final parsedPrice = double.tryParse(value.trim());
                  if (parsedPrice == null) {
                    return 'Price must be a valid number';
                  }
                  if (parsedPrice <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('manufactureDateField'),
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'ManufactureDate',
                  hintText: 'yyyy-MM-dd',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ManufactureDate is required';
                  }
                  final date = _parseDate(value);
                  if (date == null) {
                    return 'Invalid date format';
                  }
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final checkDate = DateTime(date.year, date.month, date.day);
                  if (checkDate.isAfter(today)) {
                    return 'ManufactureDate cannot be greater than current date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('createProductButton'),
                      onPressed: _submitForm,
                      child: const Text('Create'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('cancelProductButton'),
                      onPressed: _cancelForm,
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
