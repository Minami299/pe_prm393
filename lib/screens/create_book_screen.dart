import 'package:flutter/material.dart';
import 'package:pe/models/book.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        bookId: _idController.text.trim(),
        bookTitle: _titleController.text.trim(),
        publishYear: int.parse(_yearController.text.trim()),
        author: _authorController.text.trim(),
      );

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Book Created'),
            content: Text(
              'BookID: ${book.bookId}\n'
              'BookTitle: ${book.bookTitle}\n'
              'PublishYear: ${book.publishYear}\n'
              'Author: ${book.author}',
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
    _titleController.clear();
    _yearController.clear();
    _authorController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _yearController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Book create by [Mã sinh viên – Tên SV]'),
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
                key: const Key('bookIdField'),
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'BookID',
                  hintText: 'Enter book ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'BookID is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('bookTitleField'),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'BookTitle',
                  hintText: 'Enter book title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'BookTitle is required';
                  }
                  if (value.trim().length < 3) {
                    return 'BookTitle must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('publishYearField'),
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'PublishYear',
                  hintText: 'Enter publish year (1900 - 2026)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'PublishYear is required';
                  }
                  final year = int.tryParse(value.trim());
                  if (year == null) {
                    return 'PublishYear must be an integer';
                  }
                  if (year < 1900 || year > 2026) {
                    return 'PublishYear must be between 1900 and 2026';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('authorField'),
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  hintText: 'Enter author name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Author is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('createBookButton'),
                      onPressed: _submitForm,
                      child: const Text('Create'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('cancelBookButton'),
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
