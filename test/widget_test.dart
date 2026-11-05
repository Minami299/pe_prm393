import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe/screens/create_employee_screen.dart';
import 'package:pe/screens/create_product_screen.dart';
import 'package:pe/screens/create_book_screen.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    await tester.pumpWidget(MaterialApp(home: screen));
  }

  // =========================================================================
  // ĐỀ 1: EMPLOYEE MANAGEMENT TESTS
  // =========================================================================
  group('Đề 1: Employee Management Tests', () {
    testWidgets('TC01: Mo man hinh Create Employee - Hien thi day du 4 truong va cac nut',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateEmployeeScreen());

      expect(find.byKey(const Key('employeeIdField')), findsOneWidget);
      expect(find.byKey(const Key('employeeNameField')), findsOneWidget);
      expect(find.byKey(const Key('dobField')), findsOneWidget);
      expect(find.byKey(const Key('mobilePhoneField')), findsOneWidget);
      expect(find.byKey(const Key('createButton')), findsOneWidget);
      expect(find.byKey(const Key('cancelButton')), findsOneWidget);
    });

    testWidgets('TC02: Nhan Create khi chua nhap du lieu - Hien thi loi cac truong bat buoc',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateEmployeeScreen());

      await tester.tap(find.byKey(const Key('createButton')));
      await tester.pump();

      expect(find.text('EmployeeID is required'), findsOneWidget);
      expect(find.text('EmployeeName is required'), findsOneWidget);
      expect(find.text('DOB is required'), findsOneWidget);
      expect(find.text('MobilePhone is required'), findsOneWidget);
    });

    testWidgets('TC03: EmployeeName co 2 ky tu - Hien thi thong bao loi',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateEmployeeScreen());

      await tester.enterText(find.byKey(const Key('employeeNameField')), 'AB');
      await tester.tap(find.byKey(const Key('createButton')));
      await tester.pump();

      expect(find.text('EmployeeName must be at least 3 characters'), findsOneWidget);
    });

    testWidgets('TC04: DOB lon hon ngay hien tai - Khong chap nhan du lieu',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateEmployeeScreen());

      await tester.enterText(find.byKey(const Key('dobField')), '2099-12-31');
      await tester.tap(find.byKey(const Key('createButton')));
      await tester.pump();

      expect(find.text('DOB cannot be greater than current date'), findsOneWidget);
    });

    testWidgets('TC05: MobilePhone co 9 chu so - Hien thi thong bao loi',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateEmployeeScreen());

      await tester.enterText(find.byKey(const Key('mobilePhoneField')), '012345678');
      await tester.tap(find.byKey(const Key('createButton')));
      await tester.pump();

      expect(find.text('MobilePhone must have exactly 10 digits'), findsOneWidget);
    });

    testWidgets('TC06: Nhap du lieu hop le - Tao Employee thanh cong va hien thi AlertDialog',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateEmployeeScreen());

      await tester.enterText(find.byKey(const Key('employeeIdField')), 'EMP001');
      await tester.enterText(find.byKey(const Key('employeeNameField')), 'Nguyen Van A');
      await tester.enterText(find.byKey(const Key('dobField')), '2000-01-01');
      await tester.enterText(find.byKey(const Key('mobilePhoneField')), '0912345678');

      await tester.tap(find.byKey(const Key('createButton')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Employee Created'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.textContaining('EMP001'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('TC07: Nhan Cancel - Huy thao tac va xoa trang du lieu',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateEmployeeScreen());

      await tester.enterText(find.byKey(const Key('employeeIdField')), 'EMP001');
      await tester.enterText(find.byKey(const Key('employeeNameField')), 'Nguyen Van A');
      await tester.enterText(find.byKey(const Key('dobField')), '2000-01-01');
      await tester.enterText(find.byKey(const Key('mobilePhoneField')), '0912345678');

      await tester.tap(find.byKey(const Key('cancelButton')));
      await tester.pump();

      expect(find.text('EMP001'), findsNothing);
      expect(find.text('Nguyen Van A'), findsNothing);
    });
  });

  // =========================================================================
  // ĐỀ 2: PRODUCT MANAGEMENT TESTS
  // =========================================================================
  group('Đề 2: Product Management Tests', () {
    testWidgets('P_TC01: Mo man hinh Create Product - Hien thi day du 4 truong',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateProductScreen());

      expect(find.byKey(const Key('productIdField')), findsOneWidget);
      expect(find.byKey(const Key('productNameField')), findsOneWidget);
      expect(find.byKey(const Key('priceField')), findsOneWidget);
      expect(find.byKey(const Key('manufactureDateField')), findsOneWidget);
      expect(find.byKey(const Key('createProductButton')), findsOneWidget);
      expect(find.byKey(const Key('cancelProductButton')), findsOneWidget);
    });

    testWidgets('P_TC02: Nhan Create khi chua nhap du lieu - Hien thi loi cac truong bat buoc',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateProductScreen());

      await tester.tap(find.byKey(const Key('createProductButton')));
      await tester.pump();

      expect(find.text('ProductID is required'), findsOneWidget);
      expect(find.text('ProductName is required'), findsOneWidget);
      expect(find.text('Price is required'), findsOneWidget);
      expect(find.text('ManufactureDate is required'), findsOneWidget);
    });

    testWidgets('P_TC03: ProductName co 2 ky tu - Hien thi thong bao loi',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateProductScreen());

      await tester.enterText(find.byKey(const Key('productNameField')), 'SP');
      await tester.tap(find.byKey(const Key('createProductButton')));
      await tester.pump();

      expect(find.text('ProductName must be at least 3 characters'), findsOneWidget);
    });

    testWidgets('P_TC04: Price nho hon hoac bang 0 - Hien thi thong bao loi',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateProductScreen());

      await tester.enterText(find.byKey(const Key('priceField')), '0');
      await tester.tap(find.byKey(const Key('createProductButton')));
      await tester.pump();

      expect(find.text('Price must be greater than 0'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('priceField')), '-50');
      await tester.tap(find.byKey(const Key('createProductButton')));
      await tester.pump();

      expect(find.text('Price must be greater than 0'), findsOneWidget);
    });

    testWidgets('P_TC05: ManufactureDate lon hon ngay hien tai - Khong chap nhan du lieu',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateProductScreen());

      await tester.enterText(find.byKey(const Key('manufactureDateField')), '2099-12-31');
      await tester.tap(find.byKey(const Key('createProductButton')));
      await tester.pump();

      expect(find.text('ManufactureDate cannot be greater than current date'), findsOneWidget);
    });

    testWidgets('P_TC06: Nhap du lieu hop le - Tao Product thanh cong va hien thi AlertDialog',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateProductScreen());

      await tester.enterText(find.byKey(const Key('productIdField')), 'PROD01');
      await tester.enterText(find.byKey(const Key('productNameField')), 'Laptop Dell');
      await tester.enterText(find.byKey(const Key('priceField')), '1500.5');
      await tester.enterText(find.byKey(const Key('manufactureDateField')), '2024-01-15');

      await tester.tap(find.byKey(const Key('createProductButton')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Product Created'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.textContaining('PROD01'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('P_TC07: Nhan Cancel - Xoa trang du lieu Product',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateProductScreen());

      await tester.enterText(find.byKey(const Key('productIdField')), 'PROD01');
      await tester.enterText(find.byKey(const Key('productNameField')), 'Laptop Dell');
      await tester.enterText(find.byKey(const Key('priceField')), '1500.5');
      await tester.enterText(find.byKey(const Key('manufactureDateField')), '2024-01-15');

      await tester.tap(find.byKey(const Key('cancelProductButton')));
      await tester.pump();

      expect(find.text('PROD01'), findsNothing);
      expect(find.text('Laptop Dell'), findsNothing);
    });
  });

  // =========================================================================
  // ĐỀ 4: BOOK MANAGEMENT TESTS
  // =========================================================================
  group('Đề 4: Book Management Tests', () {
    testWidgets('B_TC01: Mo man hinh Create Book - Hien thi day du 4 truong',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateBookScreen());

      expect(find.byKey(const Key('bookIdField')), findsOneWidget);
      expect(find.byKey(const Key('bookTitleField')), findsOneWidget);
      expect(find.byKey(const Key('publishYearField')), findsOneWidget);
      expect(find.byKey(const Key('authorField')), findsOneWidget);
      expect(find.byKey(const Key('createBookButton')), findsOneWidget);
      expect(find.byKey(const Key('cancelBookButton')), findsOneWidget);
    });

    testWidgets('B_TC02: Nhan Create khi chua nhap du lieu - Hien thi loi cac truong bat buoc',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateBookScreen());

      await tester.tap(find.byKey(const Key('createBookButton')));
      await tester.pump();

      expect(find.text('BookID is required'), findsOneWidget);
      expect(find.text('BookTitle is required'), findsOneWidget);
      expect(find.text('PublishYear is required'), findsOneWidget);
      expect(find.text('Author is required'), findsOneWidget);
    });

    testWidgets('B_TC03: BookTitle co 2 ky tu - Hien thi thong bao loi',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateBookScreen());

      await tester.enterText(find.byKey(const Key('bookTitleField')), 'BK');
      await tester.tap(find.byKey(const Key('createBookButton')));
      await tester.pump();

      expect(find.text('BookTitle must be at least 3 characters'), findsOneWidget);
    });

    testWidgets('B_TC04: PublishYear ngoai khoang [1900 - 2026] - Hien thi thong bao loi',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateBookScreen());

      await tester.enterText(find.byKey(const Key('publishYearField')), '1899');
      await tester.tap(find.byKey(const Key('createBookButton')));
      await tester.pump();

      expect(find.text('PublishYear must be between 1900 and 2026'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('publishYearField')), '2027');
      await tester.tap(find.byKey(const Key('createBookButton')));
      await tester.pump();

      expect(find.text('PublishYear must be between 1900 and 2026'), findsOneWidget);
    });

    testWidgets('B_TC05: Nhap du lieu hop le - Tao Book thanh cong va hien thi AlertDialog',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateBookScreen());

      await tester.enterText(find.byKey(const Key('bookIdField')), 'BK001');
      await tester.enterText(find.byKey(const Key('bookTitleField')), 'Clean Code');
      await tester.enterText(find.byKey(const Key('publishYearField')), '2008');
      await tester.enterText(find.byKey(const Key('authorField')), 'Robert C. Martin');

      await tester.tap(find.byKey(const Key('createBookButton')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Book Created'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.textContaining('BK001'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('B_TC06: Nhan Cancel - Xoa trang du lieu Book',
        (WidgetTester tester) async {
      await pumpScreen(tester, const CreateBookScreen());

      await tester.enterText(find.byKey(const Key('bookIdField')), 'BK001');
      await tester.enterText(find.byKey(const Key('bookTitleField')), 'Clean Code');
      await tester.enterText(find.byKey(const Key('publishYearField')), '2008');
      await tester.enterText(find.byKey(const Key('authorField')), 'Robert C. Martin');

      await tester.tap(find.byKey(const Key('cancelBookButton')));
      await tester.pump();

      expect(find.text('BK001'), findsNothing);
      expect(find.text('Clean Code'), findsNothing);
    });
  });
}
