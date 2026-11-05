import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pe/screens/create_book_screen.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    await tester.pumpWidget(const MaterialApp(home: CreateBookScreen()));
  }

  testWidgets('B_TC01: Mo man hinh Create Book - Hien thi day du 4 truong va cac nut',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    expect(find.byKey(const Key('bookIdField')), findsOneWidget);
    expect(find.byKey(const Key('bookTitleField')), findsOneWidget);
    expect(find.byKey(const Key('publishYearField')), findsOneWidget);
    expect(find.byKey(const Key('authorField')), findsOneWidget);
    expect(find.byKey(const Key('createBookButton')), findsOneWidget);
    expect(find.byKey(const Key('cancelBookButton')), findsOneWidget);
  });

  testWidgets('B_TC02: Nhan Create khi chua nhap du lieu - Hien thi loi cac truong bat buoc',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byKey(const Key('createBookButton')));
    await tester.pump();

    expect(find.text('BookID is required'), findsOneWidget);
    expect(find.text('BookTitle is required'), findsOneWidget);
    expect(find.text('PublishYear is required'), findsOneWidget);
    expect(find.text('Author is required'), findsOneWidget);
  });

  testWidgets('B_TC03: BookTitle co 2 ky tu - Hien thi thong bao loi',
      (WidgetTester tester) async {
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('bookTitleField')), 'BK');
    await tester.tap(find.byKey(const Key('createBookButton')));
    await tester.pump();

    expect(find.text('BookTitle must be at least 3 characters'), findsOneWidget);
  });

  testWidgets('B_TC04: PublishYear ngoai khoang [1900 - 2026] - Hien thi thong bao loi',
      (WidgetTester tester) async {
    await pumpScreen(tester);

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
    await pumpScreen(tester);

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
    await pumpScreen(tester);

    await tester.enterText(find.byKey(const Key('bookIdField')), 'BK001');
    await tester.enterText(find.byKey(const Key('bookTitleField')), 'Clean Code');
    await tester.enterText(find.byKey(const Key('publishYearField')), '2008');
    await tester.enterText(find.byKey(const Key('authorField')), 'Robert C. Martin');

    await tester.tap(find.byKey(const Key('cancelBookButton')));
    await tester.pump();

    expect(find.text('BK001'), findsNothing);
    expect(find.text('Clean Code'), findsNothing);
  });
}

