import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe/screens/create_product_screen.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    await tester.pumpWidget(const MaterialApp(home: CreateProductScreen()));
  }

  testWidgets('P_TC01: Mo man hinh Create Product - Hien thi day du 4 truong va cac nut',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    expect(find.byKey(const Key('productIdField')), findsOneWidget);
    expect(find.byKey(const Key('productNameField')), findsOneWidget);
    expect(find.byKey(const Key('priceField')), findsOneWidget);
    expect(find.byKey(const Key('manufactureDateField')), findsOneWidget);
    expect(find.byKey(const Key('createProductButton')), findsOneWidget);
    expect(find.byKey(const Key('cancelProductButton')), findsOneWidget);
  });

  testWidgets('P_TC02: Nhan Create khi chua nhap du lieu - Hien thi loi cac truong bat buoc',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byKey(const Key('createProductButton')));
    await tester.pump();

    expect(find.text('ProductID is required'), findsOneWidget);
    expect(find.text('ProductName is required'), findsOneWidget);
    expect(find.text('Price is required'), findsOneWidget);
    expect(find.text('ManufactureDate is required'), findsOneWidget);
  });

  testWidgets('P_TC03: ProductName co 2 ky tu - Hien thi thong bao loi',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('productNameField')), 'SP');
    await tester.tap(find.byKey(const Key('createProductButton')));
    await tester.pump();

    expect(find.text('ProductName must be at least 3 characters'), findsOneWidget);
  });

  testWidgets('P_TC04: Price nho hon hoac bang 0 - Hien thi thong bao loi',
      (WidgetTester tester) async {
    await pumpScreen(tester);

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
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('manufactureDateField')), '2099-12-31');
    await tester.tap(find.byKey(const Key('createProductButton')));
    await tester.pump();

    expect(find.text('ManufactureDate cannot be greater than current date'), findsOneWidget);
  });

  testWidgets('P_TC06: Nhap du lieu hop le - Tao Product thanh cong va hien thi AlertDialog',
      (WidgetTester tester) async {
    await pumpScreen(tester);

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
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('productIdField')), 'PROD01');
    await tester.enterText(find.byKey(const Key('productNameField')), 'Laptop Dell');
    await tester.enterText(find.byKey(const Key('priceField')), '1500.5');
    await tester.enterText(find.byKey(const Key('manufactureDateField')), '2024-01-15');

    await tester.tap(find.byKey(const Key('cancelProductButton')));
    await tester.pump();

    expect(find.text('PROD01'), findsNothing);
    expect(find.text('Laptop Dell'), findsNothing);
  });
}

