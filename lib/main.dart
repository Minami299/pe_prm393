import 'package:flutter/material.dart';
import 'package:pe/screens/create_employee_screen.dart';
// ignore: unused_import
import 'package:pe/screens/create_product_screen.dart';
// ignore: unused_import
import 'package:pe/screens/create_book_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practical Exam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // ========================================================
      // CHỌN MÀN HÌNH THEO ĐỀ THI BẰNG CÁCH COMMENT / UNCOMMENT
      // ========================================================

      // --- ĐỀ 1: Quản lý Nhân viên (Employee Management) ---
      home: const CreateEmployeeScreen(),

      // --- ĐỀ 2: Quản lý Sản phẩm (Product Management) ---
      // home: const CreateProductScreen(),

      // --- ĐỀ 4: Quản lý Sách / Thư viện (Book Management) ---
      // home: const CreateBookScreen(),
    );
  }
}
