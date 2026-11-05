import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe/screens/create_employee_screen.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    await tester.pumpWidget(const MaterialApp(home: CreateEmployeeScreen()));
  }

  testWidgets('TC01: Mo man hinh Create Employee - Hien thi day du 4 truong va cac nut',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    expect(find.byKey(const Key('employeeIdField')), findsOneWidget);
    expect(find.byKey(const Key('employeeNameField')), findsOneWidget);
    expect(find.byKey(const Key('dobField')), findsOneWidget);
    expect(find.byKey(const Key('mobilePhoneField')), findsOneWidget);
    expect(find.byKey(const Key('createButton')), findsOneWidget);
    expect(find.byKey(const Key('cancelButton')), findsOneWidget);
  });

  testWidgets('TC02: Nhan Create khi chua nhap du lieu - Hien thi loi cac truong bat buoc',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byKey(const Key('createButton')));
    await tester.pump();

    expect(find.text('EmployeeID is required'), findsOneWidget);
    expect(find.text('EmployeeName is required'), findsOneWidget);
    expect(find.text('DOB is required'), findsOneWidget);
    expect(find.text('MobilePhone is required'), findsOneWidget);
  });

  testWidgets('TC03: EmployeeName co 2 ky tu - Hien thi thong bao loi',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('employeeNameField')), 'AB');
    await tester.tap(find.byKey(const Key('createButton')));
    await tester.pump();

    expect(find.text('EmployeeName must be at least 3 characters'), findsOneWidget);
  });

  testWidgets('TC04: DOB lon hon ngay hien tai - Khong chap nhan du lieu',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('dobField')), '2099-12-31');
    await tester.tap(find.byKey(const Key('createButton')));
    await tester.pump();

    expect(find.text('DOB cannot be greater than current date'), findsOneWidget);
  });

  testWidgets('TC05: MobilePhone co 9 chu so - Hien thi thong bao loi',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('mobilePhoneField')), '012345678');
    await tester.tap(find.byKey(const Key('createButton')));
    await tester.pump();

    expect(find.text('MobilePhone must have exactly 10 digits'), findsOneWidget);
  });

  testWidgets('TC06: Nhap du lieu hop le - Tao Employee thanh cong va hien thi AlertDialog',
      (WidgetTester tester) async {
    await pumpScreen(tester);

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
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('employeeIdField')), 'EMP001');
    await tester.enterText(find.byKey(const Key('employeeNameField')), 'Nguyen Van A');
    await tester.enterText(find.byKey(const Key('dobField')), '2000-01-01');
    await tester.enterText(find.byKey(const Key('mobilePhoneField')), '0912345678');

    await tester.tap(find.byKey(const Key('cancelButton')));
    await tester.pump();

    expect(find.text('EMP001'), findsNothing);
    expect(find.text('Nguyen Van A'), findsNothing);
  });
}
