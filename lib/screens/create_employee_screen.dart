import 'package:flutter/material.dart';
import 'package:pe/models/employee.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
    final initial = _parseDate(_dobController.text) ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        employeeId: _idController.text.trim(),
        employeeName: _nameController.text.trim(),
        dob: _parseDate(_dobController.text.trim())!,
        mobilePhone: _phoneController.text.trim(),
      );

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Employee Created'),
            content: Text(
              'EmployeeID: ${employee.employeeId}\n'
              'EmployeeName: ${employee.employeeName}\n'
              'DOB: ${_dobController.text.trim()}\n'
              'MobilePhone: ${employee.mobilePhone}',
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
    _dobController.clear();
    _phoneController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Employee create by [Mã sinh viên – Tên SV]'),
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
                key: const Key('employeeIdField'),
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'EmployeeID',
                  hintText: 'Enter employee ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'EmployeeID is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('employeeNameField'),
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'EmployeeName',
                  hintText: 'Enter employee name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'EmployeeName is required';
                  }
                  if (value.trim().length < 3) {
                    return 'EmployeeName must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('dobField'),
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'DOB',
                  hintText: 'yyyy-MM-dd',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'DOB is required';
                  }
                  final date = _parseDate(value);
                  if (date == null) {
                    return 'Invalid date format';
                  }
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final checkDate = DateTime(date.year, date.month, date.day);
                  if (checkDate.isAfter(today)) {
                    return 'DOB cannot be greater than current date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: const Key('mobilePhoneField'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'MobilePhone',
                  hintText: 'Enter 10-digit phone number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'MobilePhone is required';
                  }
                  final trimmed = value.trim();
                  final regex = RegExp(r'^[0-9]{10}$');
                  if (!regex.hasMatch(trimmed)) {
                    return 'MobilePhone must have exactly 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('createButton'),
                      onPressed: _submitForm,
                      child: const Text('Create'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('cancelButton'),
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

