import 'package:flutter_test/flutter_test.dart';
import 'package:mandalart/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MandalartApp());
    expect(find.text('만다라트'), findsOneWidget);
  });
}
