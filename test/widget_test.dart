import 'package:flutter_test/flutter_test.dart';
import 'package:book_me/main.dart';

void main() {
  testWidgets('BookMeApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BookMeApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(BookMeApp), findsOneWidget);
  });
}
